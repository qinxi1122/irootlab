%> Feature Selection (FSel) base class
%>
%> @sa get_feaidxs.m
classdef fsel < fext
    properties
        %> =[]. See get_feaidxs.m
        v = [];
        %> ='i'. See get_feaidxs.m
        v_type = 'i';
        %> =0. See get_feaidxs.m
        flag_complement = 0;
    end;
    
    
    % These are optional properties
    properties
        %> [1][nf] vector containing feature evaluation grades.
        grades = []; 
        %> x-axis values corresponding to the @c grades y-axis values
        fea_x;
        %> Name corresponding to fea_x
        xname = '';
        xunit = '';
        %> All objects with the @c grades property must have the @c grades_x property as well, to equalize for @ref bmtable
        grades_x;

        %> Name of y-axis (grades)
        yname = 'Hit';
    end;
    
    methods
        function o = fsel()
            o.classtitle = 'Feature Selection';
        end;
        
        function z = get.grades_x(o)
            z = o.fea_x;
        end;

        %> bmtable integration
        function z = get_grades_x(o, params)
            z = o.grades_x;
        end;

        %> @c params is ignored
        %>
        %> Uses the @ref grades property if not empty, otherwise builds a "hits" vector
        function z = get_grades(o, varargin)
            if ~isempty(o.grades)
                z = o.grades;
            else
                z = zeros(1, numel(o.grades_x));
                z(o.v) = 1;
            end;
        end;


        %> Draws selected features
        %>
        %> Only works if @c type is 'i' and flag_complement is false, otherwise gives an error.
        function o = draw(o, data_hint)
            if ~exist('data_hint', 'var')
                data_hint = [];
            end;

            if strcmp(o.v_type, 'i') && ~o.flag_complement
                if isempty(o.grades)
                    % Best I can do if these optional variables are empty
                    nn = max(o.v);
                    grades_ = zeros(1, nn);
                    fea_x_ = 1:nn;
                else
                    grades_ = o.grades;
                    fea_x_ = o.fea_x;
                end;

            
                if ~isempty(data_hint)
                    xhint = data_hint.fea_x;
                    yhint = mean(data_hint.X);
                else
                    xhint = [];
                    yhint = [];
                end;

                draw_loadings(fea_x_, grades_, xhint, yhint, [], 0, [], 0, 0, 0, 1); % 1 is the flag_histogram

                draw_peaks(fea_x_, o.grades_, o.v, 0);

                format_xaxis(o);
                ylabel(gca, o.yname);
            else
                irerror('v_type must be ''i'' and flag_complement must be off@!');
            end;
        end;
    end;

    methods(Access=protected)
        % This functionality is likely to be kept by descendants, which will probably concentrate on training
        function [o, data] = do_use(o, data)
            if ~(strcmp(o.v_type, 'i') && ~o.flag_complement)
                idxs = get_feaidxs(data.fea_x, o.v, o.v_type, o.flag_complement);
                data = data.select_features(idxs);
            else
                data = data.select_features(o.v);
            end;
        end;
    end;
end
