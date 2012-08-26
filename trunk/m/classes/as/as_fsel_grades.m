%> @brief Feature Selection based on a "grades" vector.
%>
%> "grades" = <code>o.input.grades</code>
%>
%> The "grades" vector is typically calculated by a @ref as_grades class.
%>
%> Based on "grades", the features are selected in a three-step procedure:
%>
%> <h3>Stage 1 (optional)</h3>
%> In this step, a @ref peakdetector is used to select "peak" features for the next stage. If this stage is skipped, all the features remain
%> for the next stage.
%> <h3>Stage 2</h3>
%> Selects a number of features, either a fixed number of best-ranked features, or all features which ranked above a threshold (see
%> as_fsel_grades::type).
%>
%> If FSG returns more than one grade vector (i.e., it uses an SGS that has 3 or more bites, or the @c data property has 3 or more elements), 
%> the second vector will be used in this stage. This corresponds to doing the 3rd stage optimization using test sets that are independent from 
%> the ones used to calculate the initial grades curve
%>
%> This is univariate feature selection
classdef as_fsel_grades < as_fsel
    properties
        %> A @ref log_grades object
        input;
        
        %> =10
        nf_select = 10;
        %> =.03
        threshold = .03;
        %> ='nf'. Possibilities: 
        %> @arg 'none': Skips the second stage
        %> @arg 'nf': o.nf_select best ranked will be selected
        %> @arg 'threshold': features with grade (o.input.grades property) above o.threshold will be selected
        type = 'nf';
        %> =[].
        peakdetector = [];
        
        %> Feature Subset Grader object. Used for optimization of number of features
        fsg = [];
        
        %> ='grade'. How to sort the selected features.
        %> @arg 'grade' descending order of grade
        %> @arg 'index' ascending order ot index
        sortmode = 'grade';
    end;
    
    methods
        function o = as_fsel_grades()
            o.classtitle = 'Grades-based';
        end;

        
        function log = go(o)
            log = log_as_fsel_grades();
            log.flag_peaks = ~isempty(o.peakdetector);
            log.type = o.type;
            log.fea_x = o.input.fea_x;
            log.xname = o.input.xname;
            log.xunit = o.input.xunit;
            log.yname = o.input.yname;
            log.yunit = o.input.yunit;
            log.grades = o.input.grades;
            log.threshold = o.threshold;
            

            GRADE = 1; INDEX = 2; % defines for "howsorted"
            
            %%%%% STAGE 1 (optional): peak detection
            if ~log.flag_peaks
                yidxs = o.input.grades;
                idxs = 1:numel(yidxs);
            else
                idxs = o.peakdetector.use(o.input.fea_x, o.input.grades);
                yidxs = o.input.grades(idxs);
            end;
            howsorted = INDEX;
            

            %%%%% STAGE 2: selection
            switch o.type
                case 'none'
                case 'nf'
                    if numel(yidxs) < o.nf_select
                        nf_effective = numel(yidxs);
                        irverbose(sprintf('INFO: Less than desired features will be selected (%d < %d)', numel(yidxs), o.nf_select), 1);
                    else
                        nf_effective = o.nf_select;
                    end;

                    [dummy, sortedidxs] = sort(yidxs, 'descend');
                    newv = sortedidxs(1:nf_effective);
                    idxs = idxs(newv);
                    yidxs = yidxs(newv);
                    howsorted = GRADE; % Descending order of grades!
                case 'threshold'
                    [foundvalues, foundidxs] = find(yidxs > o.threshold);
                    idxs = idxs(foundidxs);
                    yidxs = yidxs(foundidxs);
                otherwise
                    irerror(sprintf('Unknown univariate feature selection type ''%s''', o.type));
            end;

            
            if howsorted == GRADE && strcmp(o.sortmode, 'index')
                [idxs, dummy] = sort(idxs); %#ok<NASGU>
            elseif howsorted == INDEX && strcmp(o.sortmode, 'grade')
                [dummy, idxtemp] = sort(yidxs, 'descend');
                idxs = idxs(idxtemp);
            end;
            
            % Phew!
            log.v = idxs;
        end;
    end;    
end
