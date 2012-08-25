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
%> <h3> Stage 3 (optional)</h3>
%> Ranks the features selected in the previous stage; builds sub-sets of these features, where the first sub-set contains the best-ranked
%> feature only, and all succesive sub-sets contain the previous sub-set plus the next best-ranked feature; and grades all sub-sets using
%> the @ref as_fsel_grades::fsg object again, to find out which sub-set is the best graded.
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
        
        %> If true, uses as_fsel_grades::fsg (again) to determine the optimal number of features after ranking them
        flag_optimize = 0;

        %> Feature Subset Grader object. Used for optimization of number of features
        fsg = [];
        
        %> ='grade'. How to sort the selected features.
        %> @arg 'grade' descending order of grade
        %> @arg 'index' ascending order ot index
        sortmode = 'grade';
    end;
    
    methods
        function o = as_fsel_grades()
            o.classtitle = 'Grades using grades vector';
        end;

        
        function log = go(o)
            log = log_as_fsel_grades();
            log.flag_peaks = ~isempty(o.peakdetector);

            GRADE = 1; INDEX = 2; % defines for "howsorted"
            
            %%%%% STAGE 1 (optional): peak detection
            if ~log.flag_peaks
                grades = o.input.grades;
                idxs = 1:numel(grades);
            else
                idxs = o.peakdetector.use(o.input.fea_x, o.input.grades);
                grades = o.input.grades(idxs);
            end;
            howsorted = INDEX;
            

            %%%%% STAGE 2: selection
            switch o.type
                case 'none'
                case 'nf'
                    if numel(grades) < o.nf_select
                        nf_effective = numel(grades);
                        irverbose(sprintf('INFO: Less than desired features will be selected (%d < %d)', numel(grades), o.nf_select), 1);
                    else
                        nf_effective = o.nf_select;
                    end;

                    [dummy, sortedidxs] = sort(grades, 'descend');
                    newv = sortedidxs(1:nf_effective);
                    idxs = idxs(newv);
                    grades = grades(newv);
                    howsorted = GRADE; % Descending order of grades!
                case 'threshold'
                    [foundvalues, foundidxs] = find(grades > o.threshold);
                    idxs = idxs(foundidxs);
                    grades = grades(foundidxs);
                otherwise
                    irerror(sprintf('Unknown univariate feature selection type ''%s''', o.type));
            end;


            %%%%% STAGE 3: optimization
            if o.flag_optimize
                if howsorted ~= GRADE
                    [dummy, sortedidxs] = sort(grades, 'descend');
                    idxs = idxs(sortedidxs);
                end;
                
                n = numel(idxs);
                log.opt_subsets = cell(1, n);
                vtemp = [];
                for i = 1:n
                    vtemp = [vtemp, idxs(i)];
                    log.opt_subsets{i} = vtemp;
                end;

                % Please note that it is assumed that the FSG has been set-up already (with data, and booted) in calculate_grades(), 
                % so I won't call these, because it can be time-consuming. Otherwise, the lines would be as follow
                % % % % o.fsg.data = o.data;
                % % % % o.fsg = o.fsg.boot();
                gradestemp = o.fsg.calculate_grades(o.opt_subsets);
                if size(gradestemp, 3) > 1
                    log.opt_grades = gradestemp(:, :, 2);
                    irverbose('Used independent test sets for as_fsel_grades optimization', 2);
                else
                    log.opt_grades = gradestemp;
                end;

                [valtemp, idxtemp] = max(o.opt_grades);

                idxs = o.opt_subsets{idxtemp};
                grades = o.input.grades(idxs);
                howsorted = GRADE;
            end;
            
            if howsorted == GRADE && strcmp(o.sortmode, 'index')
                [idxs, dummy] = sort(idxs); %#ok<NASGU>
            elseif howsorted == INDEX && strcmp(o.sortmode, 'grade')
                [dummy, idxtemp] = sort(grades, 'descend');
                idxs = idxs(idxtemp);
            end;
            
            % Phew!
            log.v = idxs;
        end;
    end;    
end
