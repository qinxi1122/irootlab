%>@file
%>@ingroup maths
%
%> Grid Searc Parameter: auxiliary class for Grid Searches.
%>
%> @sa gridsearch
classdef gridsearchparam
    properties
        %> name: name of a field in '.obj'
        name = [];
        %> x1: initial lower bound
        x1 = 0;
        %> x2: initial upper bound
        x2 = 10;
        %> no_points: number of points in this dimension of the grid
        no_points = 10;
        %> flag_linear: whether to produce linearly spaced points (otherwise log-spaced)
        flag_linear = 1;
    end;
    
    methods
        function o = gridsearchparam(name_, x1_, x2_, no_points_, flag_linear_)
            if nargin >= 1 && ~isempty(name_)
                o.name = name_;
            end;
            
            if nargin >= 2 && ~isempty(x1_)
                o.x1 = x1_;
            end;
            
            if nargin >= 3 && ~isempty(x2_)
                o.x2 = x2_;
            end;
            
            if nargin >= 4 && ~isempty(no_points_)
                o.no_points = no_points_;
            end;
            
            if nargin >= 5 && ~isempty(flag_linear_)
                o.flag_linear = flag_linear_;
            end;
        end;
    end;
end
                
                
