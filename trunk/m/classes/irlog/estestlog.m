%> @brief Records estimations from the individual components of a classifier ensemble
%>
%> Using this log is limited to situations where an ensemble (i.e., an object of class @c aggr ) is trained once, then used one or more
%> times. Multiple training-test, such as cross-validation sessions, cannot be used in general because different component classifiers
%> will be generated after each training, in respect to number of classifiers in the ensemble, class labels of the component
%> classifiers etc.
classdef estestlog < ttlog
    properties
        %> Classifier  of class @c aggr . Needs to be a trained classifier.
        clssr;
        %> Log to be replicated when the @c clssr property is set.
        log_mold;
        %> Decider object to make the classes from @c pars.ests, because it probably comes classless
        decider;
    end;
    
    properties(SetAccess=private)
        estlabels;
    end;
    
    properties(SetAccess=protected)
        flag_booted = 0;
        logs;
    end;

    methods(Access=protected)

        %>
        function o = do_allocate(o, tt)
            o = o.assert_booted();
            
            for i = 1:numel(o.logs)
                o.logs{i} = o.logs{i}.allocate(tt);
            end;
        end;
    end;
    
    
    methods
        function o = estestlog(o)
            o.classtitle = 'Component Classifiers';
            o.flag_params = 0;
            o.flag_ui = 0;
        end;
        
        
        function o = assert_booted(o)
            if ~o.flag_booted
                o = o.prepare_logs();
                o.flag_booted = 1;
            end;
        end;

        
        %> Replicates @c log_mold setting each classifier classlabels as the log's collabels
        function o = prepare_logs(o)
            nb = numel(o.clssr.blocks);
            o.logs = cell(1, nb);
            for i = 1:nb
                l = o.log_mold;
                l.estlabels = o.clssr.blocks(i).classlabels;
                o.logs{i} = l;
            end;
        end;
        
        
        %> Getter for @c estlabels property.
        function z = get.estlabels(o)
            z = o.log_mold.rowlabels;
        end;

        %> This function needs @c pars to have @c ds_test , @c ests . Other fields depend on the specific class of @c log_mold
        function o = record(o, pars)
            if ~pars.clssr.flag_ests
                irerror('Classifier is not recording the estimations from the component classifiers!');
            end;
            for i = 1:numel(o.logs)
                pars2 = pars;
                pars2.ests = [];
                pars2.est = o.decider.use(pars.ests(i));
                o.logs{i} = o.logs{i}.record(pars2);
            end;
        end;
        

        %> Returns a matrix of confusion matrices side by side.
        %>
        %> The parameters are explained in @c estlog's @c get_C()
        %>
        %> @retval {C, colidxs, flag_perc}
        %>
        %> @seealso estlog
        function [C, colidxs, flag_perc] = get_C(o, t, flag_perc1, aggr, flag_renorm)
            nc = 0; % number of columns of CC
            nr = numel(o.estlabels);
            nb = numel(o.logs); % Number of blocks/logs
            ctemp = cell(1, nb);
            colidxs = zeros(1, nb+1); % Index of first column corresponding to each block
            flag_perc = 0;
            for i = 1:nb
                [ctemp{i}, flag_perc_] = o.logs{i}.get_C(t, flag_perc1, aggr, flag_renorm);
                if i == 1
                    flag_perc = flag_perc_;
                end;
                colidxs(i) = nc+1;
                nc = nc+size(ctemp{i}, 2);
            end;
            colidxs(nb+1) = nc+1;
            
            C = zeros(nr, nc);
            
            for i = 1:nb
                C(:, colidxs(i):colidxs(i+1)-1) = ctemp{i};
            end;
        end;

        
        
        %> Returns a cell that can later e.g. be converted to CSV .
        %>
        %> The parameters are explained in @c estlog's @c get_C()
        %>
        %> @retval {CC, colidxs}
        %>
        %> @seealso estlog
        function [CC, colidxs] = get_cell(o, t, flag_perc1, aggr, flag_renorm)
            [C, colidxs, flag_perc] = o.get_C(t, flag_perc1, aggr, flag_renorm);
            

            [nr, nc] = size(C);
            nc = nc+1;
            colidxs = colidxs+1;
            nr = nr+2;
            
            nb = numel(o.logs); % Number of blocks/logs
            
            CC = cell(nr, nc);
           
            
            for i = 1:numel(o.estlabels)
                CC{i+2, 1} = o.estlabels{i};
            end;
            
            for i = 1:nb
                % Populates the two lines of the column header
                CC{1, colidxs(i)} = o.clssr.blocks(i).block.get_description();
                CC(2, colidxs(i):colidxs(i+1)-1) = [{'Rejected'}, o.clssr.blocks(i).block.classlabels];
                
                % Stuffs with confusion matrix
                CC(3:nr, colidxs(i):colidxs(i+1)-1) = confusion_cell(C(1:nr-2, colidxs(i)-1:colidxs(i+1)-2), flag_perc);
            end;
        end;

        
        %> Mounts a HTML table from a cell obtained by @c get_cell()
        function s = get_cell_html(o, t, flag_perc1, aggr, flag_renorm)
            
            [C, colidxs, flag_perc] = o.get_C(t, flag_perc1, aggr, flag_renorm);
            [nr1, nc1] = size(C);
            [CC, dummy] = o.get_cell(t, flag_perc1, aggr, flag_renorm);
            [nr2, nc2] = size(CC);
            
            sperc = '';
            if flag_perc
                sperc = '%';
                C = round(C*10000)/100;
            end
            
            s = ['<table>', 10];
            
            h = cell(1, numel(colidxs)-1);
            for i = 1:numel(colidxs)-1
                h{i} = ['<td class="tdhe" colspan=', int2str(colidxs(i+1)-colidxs(i)), '>', CC{1, colidxs(i)+1}, '</td>'];
            end;
            s = cat(2, s, ['<tr><td class="tdhe">&nbsp;</td>', strcat(h{:}), '</tr>', 10]);
            h = arrayfun(@(s) ['<td class="tdhe">', s{1}, '</td>'], CC(2, 2:end), 'UniformOutput', 0);
            s = cat(2, s, ['<tr><td class="tdhe">&nbsp;</td>', strcat(h{:}), '</tr>', 10]);

        
            for i = 1:nr1
                s = cat(2, s, ['<tr><td class="tdle">', CC{i+2, 1}, '</td>', 10]);
                for j = 1:numel(colidxs)-1
                    subrow = C(i, colidxs(j):colidxs(j+1)-1);
                    if flag_perc
                        ma = 100;
                    else
                        ma = sum(subrow);
                    end;
                    h = cell(1, numel(subrow));
                    for k = 1:numel(subrow)
                        n = subrow(k);
                        [bgcolor, fgcolor] = cellcolor(n, ma, 1);
                        h{k} = ['<td class="tdnu" style="color: #', fgcolor, '; background-color: #', bgcolor, ';">', num2str(n), sperc, '</td>'];
                    end;
                    s = cat(2, s, [strcat(h{:}), 10]);
                end;
                s = cat(2, s, '</tr>', 10);
            end;
            
            s = cat(2, s, '</table>', 10);
        end;
        
        
        %> @param flag_individual Whether to print time snapshots as well.
        function s = get_insane_html(o, pars)
            if ~exist('pars', 'var'); pars = struct(); end;
            if ~isfield(pars, 'flag_individual')
                flag_individual = 0;
            else
                flag_individual = pars.flag_individual;
            end;
            if ~isfield(pars, 'flag_renorm')
                flag_renorm = 0;
            else
                flag_renorm = pars.flag_renorm;
            end;

            s = stylesheet();

            % Confusion matrices
            s = cat(2, s, '<h1>Confusion Matrices</h1>', 10);
            s = cat(2, s, '<h2>Overall</h2>', 10);
            s = cat(2, s, '<h3>Accumulated hits</h3>', 10);
            s = cat(2, s, o.get_cell_html([], 0, 1, flag_renorm));
            s = cat(2, s, '<h3>Percentages</h3>', 10);
            s = cat(2, s, '<h4>Mean</h4>', 10);
            s = cat(2, s, o.get_cell_html([], 1, 3, flag_renorm));
            s = cat(2, s, '<h4>Standard Deviation</h4>', 10);
            s = cat(2, s, o.get_cell_html([], 1, 4, flag_renorm));

            s = cat(2, s, '<hr/>', 10);

            if flag_individual
                if o.t > 1
                    ss = {'Hits', 'Percentages'};
                    s = cat(2, s, '<h2>Individual</h2>', 10);
                    for i = 1:2
                        s = cat(2, s, '<h3>', ss{i}, '</h3>', 10);
                        for j = 1:o.logs{1}.t
                            s = cat(2, s, o.get_cell_html(j, i-1, i, flag_renorm));
                        end;
                        s = cat(2, s, '<hr/>', 10);
                    end;
                end;
            end;
        end;       
    end;
end
