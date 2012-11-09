Get rid of this once I rewrite the demos to be free of it

%>@todo I feel like getting rid of this class
%>@ingroup maths
%> Grid Search
%>
%> Grid search is an simple iterative way of optimization that uses no gradients of the objective function (F(.)). Instead, it
%> evaluates F(.) at all points within a point grid and finds to find the maximum value. A new, finer grid is then formed
%> around the point that corresponds to this maximum and the process follows.
%>
%> The idea came from the guide that comes with LibSVM [1].
%> 
%> Rather than passing a vector from the domain to the objective function, this grid search assigns values to fields
%> within a structure ('.obj') and calls the objective function ('.f_get_rate()') passing '.obj' as a parameter.
%>
%> Grid search is of course not restricted to SVM neither to classifiers.
%>
%> Not published in the GUI at the moment.
%>
%> <h3>References:</h3>
%> [1] http://www.csie.ntu.edu.tw/~cjlin/papers/guide/guide.pdf.
%>
%> @sa gridsearchparam
classdef gridsearch < as
    
    properties
        no_iterations = 3;
        %> zoom factor for next iteration
        zoom = 4;
        %> Array of gridsearchparam objects
        paramspecs = gridsearchparam.empty;
        %> Object
        obj;
        %> function to be called to evaluate the object
        f_get_rate;
        %> (optional) Opportunity to define a custom (possibly indirect) way to set the parameters of the object (e.g. when using a block_cascade_base).
        f_set;
    end;
    
    properties(SetAccess=protected)
        %> Structure array containing the following fields:
        %>     .rates: matrix containing the classification rates
        %>     .ticks_best: best coordinate at the corresponding iteration
        %>     .tickss: cell containing vectors of ticks for each dimension
        %> Each element of this structure is one iteration
        result;
    end;
        
    
    methods
        function o = gridsearch(o)
            o.classtitle = 'Grid Search';
            o.flag_ui = 0;
        end;
        
        function o = add_param(o, varargin)
            if numel(o.paramspecs) >= 3
                irerror('Grid search can handle a maximum of 3 variables!');
            end;
            o.paramspecs(end+1) = gridsearchparam(varargin{:});
        end;
        
        
        function o = go(o)

            no_dims = length(o.paramspecs);
            if no_dims < 1
                irerror('No paramaters for gridsearch!');
            end;
            if no_dims > 3
                irerror('Grid search can handle a maximum of 3 variables!');
            end;


            for i_it = 1:o.no_iterations
                % resolves ticks
                tickss = cell(1, no_dims);
                for i_dim = 1:no_dims
                    ps = o.paramspecs(i_dim);
                    if i_it == 1
                        x1 = ps.x1;
                        x2 = ps.x2;
                    else
                        idx = out(i_it-1).idx_best(i_dim);
                        if idx == 1
                            x1 = out(i_it-1).tickss{i_dim}(1);
                            x2 = out(i_it-1).tickss{i_dim}(idx+1);
                        elseif idx == ps.no_points
                            x1 = out(i_it-1).tickss{i_dim}(idx-1);
                            x2 = out(i_it-1).tickss{i_dim}(idx);
                        else
                            x1 = out(i_it-1).tickss{i_dim}(idx-1);
                            x2 = out(i_it-1).tickss{i_dim}(idx+1);
                        end;

%                         centre = out(i_it-1).ticks_best(i_dim);
%                         len = (max(out(i_it-1).tickss{i_dim})-min(out(i_it-1).tickss{i_dim}))/o.zoom;
                    end;
                    

                    if ps.flag_linear
                        out(i_it).tickss{i_dim} = linspace(x1, x2, ps.no_points);
                    else
                        out(i_it).tickss{i_dim} = logspace(log10(x1), log10(x2), ps.no_points);
                    end;
                end;


                v_ptr = ones(1, no_dims);
                rate_best = -Inf;
                flag_end = 0;
                while 1
                    oo = o.obj;
                    for i_dim = 1:no_dims
                        if ~isempty(o.f_set)
                            % Opportunity to define a custom function to set the parameters
                            oo = o.f_set(oo, o.paramspecs(i_dim).name, out(i_it).tickss{i_dim}(v_ptr(i_dim)));
                        else
                            oo.(o.paramspecs(i_dim).name) = out(i_it).tickss{i_dim}(v_ptr(i_dim));
                        end;
                        fprintf('--> Now %s = %g <--\n', o.paramspecs(i_dim).name, out(i_it).tickss{i_dim}(v_ptr(i_dim)));
                    end;

                    rate = o.f_get_rate(oo);

                    if rate > rate_best
                        rate_best = rate;
                        for i_dim = 1:no_dims
                            out(i_it).idx_best(i_dim) = v_ptr(i_dim);
                        end;
                        out(i_it).rate_best = rate_best;
                    end;

                    % I don't know how to access this in other way
                    switch no_dims
                        case 1
                            out(i_it).rates(v_ptr) = rate;
                        case 2
                            out(i_it).rates(v_ptr(1), v_ptr(2)) = rate;
                        case 3
                            out(i_it).rates(v_ptr(1), v_ptr(2), v_ptr(3)) = rate;
                    end;    

                    % Increments the points vector for the next combination
                    for i_dim = no_dims:-1:1
                        if v_ptr(i_dim) < o.paramspecs(i_dim).no_points
                            v_ptr(i_dim) = v_ptr(i_dim)+1;
                            break;
                        else
                            if i_dim == 1
                                flag_end = 1;
                                break
                            else
                                v_ptr(i_dim) = 1;
                            end;
                        end;
                    end;
                    if flag_end
                        break;
                    end;
                end;
            end;
            
            o.result = out;
        end;
        
        %> Returns
        %> @param iter=last Iteration number
        function best = get_best(o, iter)
            if nargin < 2
                iter = o.no_iterations;
            end;
            re = o.result;

            dim = numel(o.paramspecs);
            best = zeros(1, dim);
            for i = 1:dim
                best(i) = re(iter).tickss{i}(re(iter).idx_best(i));
            end;
        end;
        
    end;
    
    
    
    % DRAWING
    methods
        %> 1D drawing
        %> @param iter=last Iteration number
        function draw_1d(o, iter)
            re = o.result;
            
            if numel(re(1).tickss) < 1
                irerror(sprintf('Cannot draw 1-D, grid search is %d-D!', numel(re(1).tickss)));
            end;
            
            if nargin < 2
                iter = o.no_iterations;
            end;
            
            

            xx = re(iter).tickss{1};

            plot(xx, re(iter).rates');

            
            if ~o.paramspecs(1).flag_linear
                set(gca, 'xscale', 'log');
            end;
            set(gca, 'Xlim', re(iter).tickss{1}([1, end]));
            xlabel(o.paramspecs(1).name);
            ylabel('Classification rate');
            hold on;
            
            bests = o.get_best(iter);

            plot(bests(1), re(iter).rate_best, 'pk', 'LineWidth', 3, 'MarkerSize', 15);
            title(sprintf('Grid search - iteration %d', iter));
            format_frank();
        end;

        
        
        %> The @c dim and @c idx parameters are used when there are three
        %> parameters in @ref paramspec, because in such case, one has to
        %> choose a "slice" to plot.
        %>
        %> @param iter =last Iteration number
        %> @param dim (3D parameters only) Dimension index
        %> @param idx (3D parameters only) Case index within dimension
        function aaba = drawx_get_aaba(o, iter, dim, idx)
            re = o.result;
            
            if numel(re(1).tickss) < 2
                irerror(sprintf('Cannot draw 2-D, grid search is %d-D!', numel(re(1).tickss)));
            end;
            
            if nargin < 2 || isempty(iter)
                iter = o.no_iterations;
            end;
            
            if numel(o.paramspecs) > 2
                if nargin < 4 || isempty(dim) || isempty(idx)
                    irerror('You need to specify the "dim" and "idx" parameters, because the optimization domain is 3D!');
                end;
                
                dd = [1, 2, 3];
                dd(dim) = []; % de-selects "slice" dimension from the 2-element list
                
                if dim == 1
                    aaba.rates = reshape(re(iter).rates(idx, :, :), 2, 3, 1);
                elseif dim == 2
                    aaba.rates = reshape(re(iter).rates(:, idx, :), 1, 3, 2);
                elseif dim == 3
                    aaba.rates = re(iter).rates(:, :, idx);
                else
                    irerror('More than 3 dimensions is not supported!');
                end;
                
                
                
                
                % Has to calculate the best
                [aaba.best_img, bestidx] = max(aaba.rates(:));
                besti = mod(bestidx-1, size(aaba.rates, 1))+1;
                bestj = ceil(bestidx/size(aaba.rates, 1));
                aaba.best_dom = [re(iter).tickss{dd(1)}(besti), re(iter).tickss{dd(2)}(bestj)];
            else
                dd = [1, 2];
                aaba.rates = re(iter).rates;
                
                aaba.best_dom = o.get_best(iter);
            end;
            
            aaba.xticks = re(iter).tickss{dd(1)};
            aaba.yticks = re(iter).tickss{dd(2)};
            
            aaba.best_img = re(iter).rate_best; % Best rate
            
            aaba.xlabel = o.paramspecs(dd(1)).name;
            aaba.ylabel = o.paramspecs(dd(2)).name;
            
            aaba.flag_linx = o.paramspecs(dd(1)).flag_linear;
            aaba.flag_liny = o.paramspecs(dd(2)).flag_linear;
            
            aaba.dd = dd;
            aaba.iter = iter;
            
            aaba.rates = aaba.rates;
        end;
        
        %> 2D drawing
        %>
        %> For parameters description, see drawx_get_aaba()
        %>
        %> @sa drawx_get_aaba()
        function draw_2d(o, iter, dim, idx)
            global SCALE;
            if nargin < 2
                iter = [];
            end;
            if nargin < 3
                dim = [];
            end;
            if nargin < 4
                idx = [];
            end;
            
            aaba = o.drawx_get_aaba(iter, dim, idx);

            [xx, yy] = meshgrid(aaba.xticks, aaba.yticks);

            mesh(xx, yy, aaba.rates');
            hold on;

            if ~aaba.flag_linx 
                set(gca, 'xscale', 'log');
            end;
            if ~aaba.flag_liny
                set(gca, 'yscale', 'log');
            end;
            set(gca, 'Xlim', aaba.xticks([1, end]), 'Ylim', aaba.yticks([1, end]));

            xlabel(aaba.xlabel);
            ylabel(aaba.ylabel);
            
            zlabel('Classification rate');

            plot3(aaba.best_dom(1), aaba.best_dom(2), aaba.best_img, 'pk', 'LineWidth', 2*SCALE, 'MarkerSize', 15*SCALE);
            title(sprintf('Grid search - iteration %d', aaba.iter));
            format_frank();
            
        end;

                
        %> Draws as image
        %>
        %> For parameters description, see drawx_get_aaba()
        %>
        %> @sa drawx_get_aaba()
        %> @param flag_normalize Will treat the rates as ranging from 0 to
        %> 100 and use image() instead of imagesc(). This is useful if you
        %> want to compare colors across different plots
        function draw_image(o, iter, dim, idx, flag_normalize, clim)
            global SCALE;
            
            if nargin < 2
                iter = [];
            end;
            if nargin < 3
                dim = [];
            end;
            if nargin < 4
                idx = [];
            end;
            
            if nargin < 5 || isempty(flag_normalize)
                flag_normalize = 0;
            end;
            
            if nargin < 6 || isempty(clim)
                clim = [0, 100];
            end;
            
            aaba = o.drawx_get_aaba(iter, dim, idx);

            
            if ~aaba.flag_linx 
                xticks = log10(aaba.xticks);
                xla = sprintf('log_{10}(%s)', aaba.xlabel);
                xbest = log10(aaba.best_dom(1));
            else
                xticks = aaba.xticks;
                xla = aaba.xlabel;
                xbest = aaba.best_dom(1);
            end;
            if ~aaba.flag_liny 
                yticks = log10(aaba.yticks);
                yla = sprintf('log_{10}(%s)', aaba.ylabel);
                ybest = log10(aaba.best_dom(2));
            else
                yticks = aaba.yticks;
                yla = aaba.ylabel;
                ybest = aaba.best_dom(2);
            end;
            
            if flag_normalize
                set(gca, 'CLim', clim);
                image(xticks, yticks, aaba.rates', 'CDataMapping', 'scaled');
                set(gca, 'CLim', clim);
            else
                imagesc(xticks, yticks, aaba.rates');
            end;
            axis image;
            hold on;
%             imagesc(aaba.rates');


            

%             set(gca, 'Xlim', aaba.xticks([1, end]), 'Ylim', aaba.yticks([1, end]));
            

            xlabel(xla);
            ylabel(yla);
            
            plot3(xbest, ybest, aaba.best_img, 'pk', 'LineWidth', 2*SCALE, 'MarkerSize', 15*SCALE);
            title(sprintf('Grid search - iteration %d', aaba.iter));
            h = colorbar;
            set(h, 'LineWidth', 30);
            format_frank([], [], h);
        end;

    end;
    
    
    methods(Access=protected)
        function v = get_ticks(o, centre, length, no_points)
            x1 = centre-length/2;
            x2 = centre+length/2;
            v = linspace(x1, x2, no_points);
        end

    end;
end
