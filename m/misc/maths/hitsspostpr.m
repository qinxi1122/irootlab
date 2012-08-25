%>@ingroup maths
%>@file
%>@brief "hitss" post-processor class
classdef hitsspostpr
    properties
        %> Probably calculated by a @ref as_fsel_hist
        hitss;
        
        %> ='uniform'. This is how the hits will be weighted in order to generate an overall histogram
        %> @arg 'uniform' All hits will have weight 1
        %> @arg 'stability' .......  kun' Hits will have weights depending on the univariate Kuncheva stability index of the selection position
        %>            (i.e., 1st feature to be selected, 2nd feature to be selected etc)
        %>
        %> I honestly think that 'uniform' is the best option to keep things simple.
        weightmode = 'uniform';
        
        %> ='kun'. stability type to pass to the function ref featurestability.m
        stabilitytype = 'kun';
    end;
        

    % Calculations
    methods
        function z = get_stabilities(o)
            z = featurestability(o.hitss, 
            
            
    
    
    methods
        %> Calculates histss and grades based on the @ref subsets property.
        %>
        %> This can only work if FFS (Forwrd feature Selection) is being used
        function o = update_from_subsets(o)
%             assert_ffs();
            w = o.get_hitweights();
            
            o.hitss = zeros(o.as_fsel.nf_select, numel(o.fea_x));
            
            
            nreps = numel(o.subsets);
            
            for i = 1:nreps
                s = o.subsets{i};
                for j = 1:numel(s)
                    o.hitss(j, s(j)) = o.hitss(j, s(j))+w(j);
                end;
            end;
            
            if isempty(o.nf4grades)
                n = size(o.hitss, 1);
            else
                n = o.nf4grades;
            end;
            o.grades = sum(o.hitss(1:n, :), 1);
        end;
        
        
        %> Returns the "Hit Weights".
        %>
        %> Hit weights are used to give, when assembling the histograms, more importance to variables that are selected first
        function w = get_hitweights(o)
            nnf = o.as_fsel.nf_select;
            
            switch o.weightmode
                case 'uniform'
                    w = ones(1, nnf);
                case 'lin'
                    irerror('"lin" not implemented yet');
                case 'exp'
                    irerror('"exp" not implemented yet');
                case 'sig'
                    irerror('"sig" not implemented yet');
                case 'kun'
                    
                    Gonna use the external fnction instead
                    
                    % This is the quickest way possible that I found to implement equation (6), considering:
                    % - the subset cardinality, k=1
                    % - the subset intersection, r=0 or r=1 (only two options)
                    %
                    % The formula I_c(r-k^2/nf)/(k-k^2/nf) = (nf*r-1)/(nf-1), which has two possible values: -1/(nf-1), or 1
                    % (stability index)
                    % 
                    % The stability index is the pairwise average. I used meshgrid to do this
                    
                    nf = numel(o.fea_x);
                    % M will be a [no_reps]x[n] matrix
                    nreps = numel(o.subsets);
                    M = NaN(nreps, nnf);
                    for i = 1:nreps
                        s = o.subsets{i};
                        M(i, 1:length(s)) = s;
                    end;
                    
                    a = 1/(nf+1);

                    for i = 1:nnf
                        m = M(:, i);
                        [XX, YY] = meshgrid(m, m);
                        B = (XX == YY);
                        
                        w(i) = (sum(B(:)*(1+a)-a)-nreps)/(nreps*(nreps-1));
                    end;
            end;
        end;
    end;
end