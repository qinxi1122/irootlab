%> @brief Log of estimation activities that records only right/wrong/rejected.
%>
%> For right/wrong to be detected, classlabels from estimation and test datasets need to follow same system, which is
%> represented by the @c estlabels property.
classdef estlog_rightwrong < estlog
    properties
        %> All possible class labels in estimation datasets
        estlabels = {};
    end;
    
    methods
        function o = estlog_rightwrong()
            o.classtitle = 'Right/Wrong';
        end;
        
        %> Returns average sensitivity. Calculated as normalized sum.
        function z = get_rate(o)
            C = o.get_C([], 0, 2);  % Gets normalized sum
            div = 1-C(1, 1); % Note that if element in first column is 1, others will be 0.
            div(div == 0) = 1; % prevents 0/0 which becomes 0/1.
            z = C(1, 2)/div; % Discounts rejected items
        end;
        
        %> Returns average sensitivity vector calculated time-wise.
        function z = get_rates(o)
            CC = o.get_C([], 1, 0); % gets 3D time-wise normalized 
            div = (1-CC(:, 1, :)); % Note that if element in first column is 1, others will be 0.
            div(div == 0) = 1; % prevents 0/0 which becomes 0/1.
            z = CC(1, 2, :)./div; % Discounts rejected items
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
            dref = pars.dref;
            classes1 = renumber_classes(est.classes, est.classlabels, o.estlabels);
            classes2 = renumber_classes(dref.classes, dref.classlabels, o.estlabels);
            
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
