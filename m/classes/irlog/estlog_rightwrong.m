%> @brief Records (1)x([rejected, right, wrong]) hits
%>
%> For right/wrong to be detected, classlabels from estimation and test datasets need to follow same system, which is
%> represented by the @c estlabels property.
classdef estlog_rightwrong < estlog
    properties
        %> All possible class labels in estimation datasets
        estlabels = {};
        %> =0. What to give as a "rate". 0-percentage of "right" guesses; 1-arbitrary element addressed by idx_rate
        ratemode = 0;
        %> =1. Index of element: 1-rejected; 2-right; 3-wrong
        idx_rate;
    end;
    
    methods
        function o = estlog_rightwrong()
            o.classtitle = 'Right/Wrong';
            o.flag_params = 1;
        end;
        
        %> Returns average sensitivity. Calculated as normalized sum.
        function z = get_rate(o)
            C = o.get_C([], 0, 2);  % Gets normalized sum
            if o.idx_rate == 1
                z = C(1);
            else
                div = 100-C(1, 1)+realmin; % Note that if element in first column is 1, others will be 0.
                z = 100*C(1, o.idx_rate)/div; % Discounts rejected items
            end;
        end;
        
        %> Returns vector of time-wise averages.
        function z = get_rates(o)
            CC = o.get_C([], 1, 0); % gets 3D time-wise normalized 
            if o.idx_rate == 1
                z = permute(CC(1, 1, :), [1, 3, 2]);
            else
                div = (100-CC(:, 1, :))+realmin; % Note that if element in first column is 1, others will be 0.
                z = 100*CC(1, o.idx_rate, :)./div; % Discounts rejected items
            end;
        end;
    end;
    
    methods(Access=protected)
        %> Returns fixed {'Right', 'Wrong'} cell.
        function z = get_collabels(o)
            z = {'Right', 'Wrong'};
        end;
        
        %> Returns fixed {'---'} cell.
        function z = get_rowlabels(o)
            z = {'---'};
        end;
        
        function o = do_record(o, pars)
            est = pars.est;
            ds_test = pars.ds_test;
            classes1 = renumber_classes(est.classes, est.classlabels, o.estlabels);
            classes2 = renumber_classes(ds_test.classes, ds_test.classlabels, o.estlabels);
            
            boolc = classes1 == classes2;
            boolr = classes1 == -1;
            no_correct = sum(boolc);
            no_reject = sum(boolr);
            o.hits(:, :, o.t) = [no_reject, no_correct, est.no-no_reject-no_correct];
            
            if o.flag_support
                o.supports(:, :, o.t) = {est.X(boolr, :)', est.X(boolc, :)', est.X(~boolc & ~boolr, :)'};
            end;
        end;
    end;
end
