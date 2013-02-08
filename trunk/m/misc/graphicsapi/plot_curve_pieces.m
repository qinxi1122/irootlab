%>@ingroup graphicsapi
%>@file
%>@brief Plots a curve in pieces if there is a discontinuity in the x-axis 
%>
%> Mimics the plot() function, but does several plots if x does not have the same increment step.
%
%> @param x
%> @param y
%> @param varargin Will be by-passed to MATLAB's <code>plot()</code>
%> @return handles a cell of handles
function h = plot_curve_pieces(x, y, varargin)

x(y == Inf) = [];
y(y == Inf) = [];

x = round(x*100)/100;

% modedelta = abs(mode(diff(x)));
% tol = 1.1*abs(modedelta); % distance difference tolerance

no_points = length(x);
i = 1;
no_plots = 0;
while 1
    flag_break = i > no_points;
    flag_plot = 0;
    flag_new_piece = 0;
    
    if flag_break
        flag_plot = 1;
    else
        if i == 1
            flag_new_piece = 1;
        else
            if i > 2
                dist = abs(x(i)-x(i-1));
                tol = abs(x(i-1)-x(i-2));

                if dist > tol*1.9
                    flag_plot = 1;
                    flag_new_piece = 1;
                end;
            end;        
        end;
    end;

    if flag_plot
        no_plots = no_plots+1;
        
        if i-piece_start > 1
            h{no_plots} = plot(x(piece_start:i-1), y(piece_start:i-1), varargin{:});
        else
            % 1-point plot
            h{no_plots} = plot(x(piece_start:i-1)*[1, 1]+[-modedelta, modedelta]*.3, y(piece_start:i-1)*[1, 1], varargin{:});
        end;
        hold on;
    end;
    
    if flag_break
        break;
    end;
    
    if flag_new_piece
        piece_start = i;
    end;
    
%     if i > 1
%         dist_old = dist;
%     end;
    i = i+1;
end;

