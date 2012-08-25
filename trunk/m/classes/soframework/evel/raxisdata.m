%> @brief Axis data for a sovalues object or a rresult object
%>
%>
classdef raxisdata
    properties(Dependent)
        label;
        values;
        %> If empty, returns the valuees converted into a cell of strings
        ticks;
        %> If empty, returns the ticks
        legends;
    end;

    properties(Access=private)
        label_;
        values_;
        ticks_;
        legends_;
    end;

    
    methods
        function z = get.label(o)
            if isempty(o.label_)
                z = 'Label';
            else
                z = o.label_;
            end;
        end;
        
        function z = get.values(o)
            if isempty(o.values_)
                z = []; % Values not set
            else
                z = o.values_;
            end;            
        end;
        
        function z = get.ticks(o)
            if isempty(o.ticks_)
                z = arrayfun(@(x) sprintf('%.3g', x), o.values, 'UniformOutput', 0);
            else
                z = o.ticks_;
            end;
        end;
        
        function z = get.legends(o)
            if isempty(o.legends_)
                z = o.ticks;
            else
                z = o.legends_;
            end;
        end;
        
        function o = set.label(o, x)
            o.label_ = x;
        end;
        
        function o = set.values(o, x)
            o.values_ = x;
        end;
        
        function o = set.ticks(o, x)
            o.ticks_ = x;
        end;

        function o = set.legends(o, x)
            o.legends_ = x;
        end;
    end;
end
