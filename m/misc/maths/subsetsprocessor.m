%>@ingroup maths
%>@file
%>@brief Processor of a set of subsets of features
%>
%> @arg Histogram generation
%> @arg "grades" vector calculation from histogram
%>
%> <h3>Usage</h3>
%> Set the @ref subsets and @ref nf properties, and call go().
%>
%> Of course there is a lot of customization. @ref nf4gradesmode, @ref nf4grades, @ref staibilitythreshold, @ref weightmode, and @ref stabilitype are
%> all properties that affect the way in which @ref grades is calculated.
%>
%> @ref gradethreshold is applied after @ref grades has been calculated.
classdef subsetsprocessor < as
    properties
        %> A @ref log_fselrepeater object
        input;

        %> Number of position-related histograms to add up to form the grades. If not specified, will use the maximum
        nf4grades = [];
        
        %> ='fixed'.
        %> @arg @c 'fixed' will apply the number specified by the @ref nf4grades property
        %> @arg @c 'stability' will use a stability threshold (@ref stabilitythreshold property).
        %>      Per-position stabilities will be calculated according to @ref stabilitytype
        nf4gradesmode = 'fixed';
        
        %> =0.05 (5%). Stability threshold specified as a percentage of maximum stability found.
        stabilitythreshold = .05;
        
        %> ='uniform'. This is how the hits will be weighted in order to generate an overall histogram
        %> @arg 'uniform' All hits will have weight 1
        %> @arg 'stability' .......  kun' Hits will have weights depending on the univariate Kuncheva stability index of the selection position
        %>            (i.e., 1st feature to be selected, 2nd feature to be selected etc)
        %>
        %> I honestly think that 'uniform' is the best option to keep things simple.
        weightmode = 'uniform';
        
        %> ='kun'. stability type to pass to the function ref featurestability.m
        stabilitytype = 'kun';
        
% % % % %         %> =0 (without effect). 

       % Post-processing of the HISTOGRAMS AFTER generated
       
       %> =0. Minimum number of hits within the histogram matrix. All values will be trimmed to zero below that. It is expressed
       %> as a fraction of the total number of hits of each position-wise histogram.
       minhits_perc = 0;
    end;
    
    properties(Dependent)
        %> Number of features of dataset
        nf = [];
    end;

    
    
    methods
        function o = subsetsprocessor()
            o.classtitle = 'Feature subsets processor';
        end;
    end;
    
    
    % Calculations
    methods
        function nf = get.nf(o)
            nf = numel(o.input.fea_x);
        end;
        
        function log = go(o)
            log = log_hist();
            log.hitss = o.get_hitss();
            
            n = o.get_nf4grades();
            log.nf4grades = n;
            
            log.grades = sum(log.hitss(1:n, :), 1);
            log.xname = o.input.xname;
            log.xunit = o.input.xunit;
            log.fea_x = o.input.fea_x;
            log.yname = 'Hits';
            log.yunit = '';
        end;
        
        function n = get_nf4grades(o)
            switch o.nf4gradesmode
                case 'fixed'
                    if isempty(o.nf4grades)
                        n = o.get_nf_select();
                    else
                        n = o.nf4grades;
                    end;
                case 'stability'
                    w = o.get_stabilities();
                    wmax = max(w);
                    ii = find(w/wmax < o.stabilitythreshold);
                    if ~isempty(ii)
                        n = ii(1)-1;
                    else
                        n = o.get_nf_select();
                    end;
                    
                otherwise
                    irerror(sprintf('nf4gradesmode "%s" invalid', o.nf4gradesmode));
            end;
        end;
        
        %> Calculates the number of features to be selected as the maximum subset size
        function n = get_nf_select(o)
            n = max(cellfun(@numel, o.input.subsets));
        end;
        

        %> Returns the "Hit Weights".
        %>
        %> Hit weights are used to give, when assembling the histograms, more importance to variables that are selected first
        function w = get_positionweights(o)
            nnf = o.get_nf_select();
            
            switch o.weightmode
                case 'uniform'
                    w = ones(1, nnf);
                case 'lin'
                    irerror('"lin" not implemented yet');
                case 'exp'
                    irerror('"exp" not implemented yet');
                case 'sig'
                    irerror('"sig" not implemented yet');
                case 'stability'
                    w = o.get_stabilities();
            end;
        end;

        
        %> Calculates histss from the subsets property.
        function H = get_hitss(o)
            subsets = o.input.subsets;
            w = o.get_positionweights();
            
            H = zeros(o.get_nf_select(), o.nf);
            
            
            nreps = numel(subsets);
            
            for i = 1:nreps
                s = subsets{i};
                for j = 1:numel(s)
                    H(j, s(j)) = H(j, s(j))+w(j);
                end;
            end;
            
            % Post-processing
            
            if o.minhits_perc > 0
                ma = sum(H(1, :));
                H(H < ma*o.minhits_perc) = 0;
            end;
        end;

        %> Returns a (feature position)x(stability curve)
        %>
        %> Calculates according to the @ref stabilitytype property
        function z = get_stabilities(o)
            z = o.input.get_stabilities(o.stabilitytype, 'uni');
        end;
    end;
end