%> @brief Trained Standardization
classdef pre_std < pre
    properties(SetAccess=private)
        means = [];
        stds = [];
    end;
    
    methods
        function o = pre_std(o)
            o.classtitle = 'Trained Standardization';
            o.flag_trainable = 1;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        % Trains block: records variable means and standard deviations
        function o = do_train(o, data)
            o.means = mean(data.X, 1);
            o.stds = std(data.X, 1);
        end;
        
        
        % Applies block to dataset
        function [o, data] = do_use(o, data)
            data.X = bsxfun(@rdivide, bsxfun(@minus, data.X, o.means), o.stds+realmin);
        end;
    end;
end