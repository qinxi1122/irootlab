%> @brief Wrapper for MATLAB classify() function
%>
%> See MATLAB's classify() function.
%>
%> @sa uip_clssr_cla.m
classdef clssr_cla < clssr
    properties
        %> = 'linear'. classifier type. See MATLAB's classify() (Statistics Toolbox) for complete list of options
        type = 'linear';
    end;
    
    properties(Access=private)
        X;
        classes;
    end;

    methods
        function o = clssr_cla(o)
            o.classtitle = 'MATLAB classify()';
        end;
        
        function s = get_description(o)
            if ~isempty(o.title)
                s = get_description@clssr(o);
            else
                s = [get_description@clssr(o), ' type = ', o.type];
            end;
        end;
    end;
    
    methods(Access=protected)
        
        
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            % Training function needs stay with X and classes because training and testing is gone in a single call to
            % classify()
            tic;
            o.X = data.X;
            o.classes = o.get_classes(data); % classes need be numbered according to the classifier's classlabels, not data's
            if size(o.X, 1) ~= size(o.classes, 1)
                irerror('Number of rows in X is unequal to number of rows in classes!');
            end;
            o.time_train = toc; % this time is meaningless

        end;
        
        
        
        function [o, est] = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);
            t = tic();
            [classes, errs, posteriors] = classify(data.X, o.X, o.classes, o.type);
            est.X = posteriors;
            o.time_use = toc(t);
        end;
        
    end;
end