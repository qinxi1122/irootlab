%> @brief Estimation logs base class.
%>
%> This Train-Test Log descendant records hits based on correct estimations and generates @ref confusion matrices and
%> datasets of supports (i.e., posterior probabilities) on demand.
%>
%> The unit of what is returned is "%"
classdef estlog < ttlog
    properties(SetAccess=private)
        collabels;
        rowlabels;
    end;
    
    properties
        %> =0. Whether or not to record the "supports" (confidence levels issued by classifiers).
        %> The default behaviour is to only count the hits for each "time" instant. Recording all the individual
        %> supports can generate a lot of data, but will allow one to plot the distribution of supports later.
        flag_support = 0;
    end;

    properties
        %> Whether there is a "refuse-to-decide" potential situation (usually the @ref decider of the object that
        %> generated the @ref estlog has a threshold > 0). It is automatically determined by verifying whether there is a non-zero element in the first column
        flag_rejected;
    end;
    
    properties(SetAccess=protected)
        %> 3D matrix: (number of groups)x(number of classes in @c labels_cols + 1)x(time)
        hits = [];
        %> Same size as hits, but it is a cell of vectors.
        supports;
        %> Whether the class is able to produce the sensitivity and specificity figures
        flag_sensspec = 0;
    end;

    methods
        function flag = get.flag_rejected(o)
            flag = ~isempty(o.hits) && any(o.hits(:, 1, :) > 0);
        end;
    end;

    methods(Access=protected)
        %> Abstract.
        function o = do_record(o, pars)
        end;

        %> Abstract.
        function z = get_collabels(o)
            z = {};
        end;
        
        %> Abstract.
        function z = get_rowlabels(o)
            z = {};
        end;

        %>
        function o = do_allocate(o, tt)
            if ~o.flag_inc_t
%                 if nargin > 1 && tt > 1
%                     irverbose('Warning: do_allocate() called with tt > 1 but flag_inc_t is false, will be ignored', 1);
%                 end;
                tt = 1;
            end;
            o.hits = zeros(numel(o.rowlabels), numel(o.collabels)+1, tt);
            if o.flag_support
%                 o.rpropv(tt).sup = [];
                o.supports = cell(numel(o.rowlabels), numel(o.collabels)+1, tt);
            end;
        end;
    end;
    
    
    methods
        function o = estlog(o)
            o.classtitle = 'Estimation';
            o.flag_params = 0;
            o.moreactions = [o.moreactions, {'extract_confusion'}];
        end;

        %> Getter for @c collabels property, calls @c get_collabels() .
        function z = get.collabels(o)
            z = o.get_collabels();
        end;

        %> Getter for @c rowlabels property, calls @c get_rowlabels() .
        function z = get.rowlabels(o)
            z = o.get_rowlabels();
        end;

        %>
        function o = record(o, pars)
%             if isempty(o.rowlabels)
%                 irerror('Empty row labels!');
%             end;
%             if isempty(o.rowlabels)
%                 irerror('Empty row labels!');
%             end;
                
            
            if o.flag_inc_t || o.t == 0
                o.t = o.t+1;
            end;
            
            if size(o.hits, 3) < o.t
                o.hits(numel(o.rowlabels), numel(o.collabels)+1, o.t) = 0; % Ellongates hits
            end;

            o = o.do_record(pars);
        end;

        %> @brief Returns a calculation over the "hits" matrix
        %>
        %> <ul>
        %>   <li>Pre-selection stage using @c t</li>
        %>   <li>t-wise normalization depending on @c flag_perc1</li>
        %>   <li>Aggregation:<ul>
        %>      <li>@c 0 - none</li>
        %>      <li>@c 1 - Sum</li>
        %>      <li>@c 2 - Sum->Normalization</li>
        %>      <li>@c 3 - Mean</li>
        %>      <li>@c 4 - Standard Deviation</li></ul></li>
        %>      <li>@c 5 - Minimum</li></ul></li>
        %>      <li>@c 6 - Maximum</li></ul></li>
        %> </ul>
        %> @param flag_renorm Renormalize (whether to discount the rejected items from percentages)?
        %> @retval [C] or [C, flag_perc]
        %>
        %> @note Percentual outputs range from 0 to 100, not from 0 to 1
        function varargout = get_C(o, t, flag_perc1, aggr, flag_renorm)
            
            if ~exist('flag_renorm', 'var')
                flag_renorm = 0;
            end;
            
            % Pre-selection
            if ~exist('t', 'var') || isempty(t) || sum(t < 1)
                C = o.hits;
            else
                C = o.hits(:, :, t);
            end;
            
            [nrow, ncol, nt] = size(C);
            
            if exist('flag_perc1', 'var') && flag_perc1
                for i = 1:nt
                    S = sum(C(:, :, i), 2);
                    S(S == 0) = 1; % makes 0/0 divisions into 0/1 ones
                    C(:, :, i) = C(:, :, i)./repmat(S, 1, ncol);
                end;
            end;
            
            if exist('aggr', 'var')
                switch (aggr)
                    case 0
                        % Does nothing
                    case 1
                        C = sum(C, 3);
                    case 2
                        C = sum(C, 3);
                        S = sum(C, 2);
                        S(S == 0) = 1; % makes 0/0 divisions into 0/1 ones
                        C = C./repmat(S, 1, ncol);
                    case 3
                        S = sum(sum(C, 2) ~= 0, 3); % counts non-zero t-wise rows for each row
                        C = sum(C, 3)./repmat(S, 1, ncol);
                    case 4
                        T = zeros(nrow, ncol);
                        for i = 1:nrow
                            temp = C(i, :, :);
                            sel = sum(temp, 2) ~= 0;
                            T(i, :) = std(temp(1, :, sel), [], 3);
                        end;
                        C = T;
                    case 5
                        C = min(C, [], 2);
                    case 6
                        C = max(C, [], 2);
                    otherwise
                        irerror(sprintf('Invalid option: %d', aggr));
                end;
            end;

            flag_perc = aggr == 2 || (flag_perc1 && any(aggr == [0, 2, 3, 4, 5, 6]));
            
            if flag_perc
                if flag_renorm
                    for i = 1:size(C, 1)
                        C(i, 2:end) = C(i, 2:end)/(1-C(i, 1)+realmin);
                    end;
%                 else
%                     S = sum(C, 2)+realmin;
%                     C = C./repmat(S, 1, size(C, 2));
                end;
                C = C*100;
            end;
            
            if nargout == 1
                varargout = {C};
            else
                varargout = {C, flag_perc};
            end;
        end;
        
        
        %> <ul>
        %>   <li>Aggregation:<ul>
        %>      <li>@c 0 - INVALID</li>
        %>      <li>@c 1 - INVALID</li>
        %>      <li>@c 2 - INVALID</li>
        %>      <li>@c 3 - Mean</li>
        %>      <li>@c 4 - Standard Deviation</li></ul></li>
        %>      <li>@c 5 - Minimum</li></ul></li>
        %>      <li>@c 6 - Maximum</li></ul></li>
        %> </ul>
        %>
        %> @brief Gets the recorded supports
        function C = get_C_supp(o, t, aggr)
            if ~o.flag_support
                irerror('Not recording supports!');
            end;
            
            % Pre-selection
            if ~exist('t', 'var') || isempty(t) || sum(t < 1)
                S = o.supports;
            else
                S = o.supports(:, :, t);
            end;

            
            [ni, nj, nk] = size(o.supports);
            C = zeros(ni, nj);
            
            for i = 1:ni
                for j = 1:nj
                    v = [S{i, j, :}];
                    if isempty(v)
                        v = 0;
                    end;
                    
                    switch (aggr)
                        case 3
                            C(i, j) = mean(v);
                        case 4
                            C(i, j) = std(v);
                        case 5
                            C(i, j) = min(v);
                        case 6
                            C(i, j) = max(v);
                        otherwise
                            irerror(sprintf('Invalid option: %d', aggr));
                    end;
                end;
            end;
        end;
        
        function oc = get_confusion_from_C(o, C, flag_perc)
            oc = irconfusion();
            oc.collabels = o.get_collabels();
            oc.rowlabels = o.get_rowlabels();
            oc.flag_perc = flag_perc;
            oc.C = C;
        end;
        
        function oc = get_confusion_sup(o, t, aggr)
            if ~exist('t', 'var')
                t = [];
            end;
            C = o.get_C_supp(t, aggr);
            oc = o.get_confusion_from_C(C);
        end;

        
        function oc = get_confusion(o, t, flag_perc1, aggr, flag_renorm)
            if ~exist('t', 'var')
                t = [];
            end;
            if ~exist('flag_perc1', 'var')
                flag_perc1 = [];
            end;
            if ~exist('aggr', 'var')
                aggr = [];
            end;

            if ~exist('flag_renorm', 'var')
                flag_renorm = 0;
            end;

            [C, flag_perc] = o.get_C(t, flag_perc1, aggr, flag_renorm);
            oc = o.get_confusion_from_C(C, flag_perc);
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
            if ~isfield(pars, 'flag_balls')
                flag_balls = 0;
            else
                flag_balls = pars.flag_balls;
            end;
            
            
            s = ['<h1>', o.get_description(), '</h1>', 10];

            if flag_balls
                % Confusion balls
                oc = o.get_confusion([], 1, 3, flag_renorm);

                vb = vis_balls();
                figure;
                vb.use(oc);
                s = cat(2, s, irreport.save_n_close([], 0));
            end;

            
            % Confusion matrices
            s = cat(2, s, '<h2>Confusion Matrices</h2>', 10);
            s = cat(2, s, '<h3>Overall</h3>', 10);
            s = cat(2, s, '<h4>Percentages</h4>', 10);
            s = cat(2, s, '<h5>Mean</h5>', 10);
            oc = o.get_confusion([], 1, 3, flag_renorm); s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
            s = cat(2, s, '<h5>Standard Deviation</h5>', 10);
            oc = o.get_confusion([], 1, 4);
            s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
            s = cat(2, s, '<h4>Accumulated hits</h4>', 10);
            oc = o.get_confusion([], 0, 1); s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
           
            if o.flag_support
                s = cat(2, s, '<h4>Supports</h4>', 10);
                s = cat(2, s, '<h5>Mean</h5>', 10);
                oc = o.get_confusion_sup([], 3); s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
                s = cat(2, s, '<h5>Standard Deviation</h5>', 10);
                oc = o.get_confusion_sup([], 4); s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
            end;
            s = cat(2, s, '<hr/>', 10);

            if flag_individual
                if o.t > 1
                    ss = {'Hits', 'Percentages'};
                    s = cat(2, s, '<h3>Individual</h3>', 10);
                    for i = 1:2
                        s = cat(2, s, '<h4>', ss{i}, '</h4>', 10);
                        for j = 1:o.t
                            oc = o.get_confusion(j, i-1, i, flag_renorm); s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
                        end;
                        s = cat(2, s, '<hr/>', 10);
                    end;

                    if o.flag_support
                        s = cat(2, s, '<h4>Supports (means)</h4>', 10);
                        for j = 1:o.t
                            oc = o.get_confusion_sup(j, 3); s = cat(2, s, '<center>', oc.get_html_table(), '</center>');
                        end;
                        s = cat(2, s, '<hr/>', 10);
                    end;
                end;
            end;
        end;
        
        %> Generates one dataset per row containing percentages.
        %> The i-th dataset, j-th feature corresponds to the classification rates of consufion cell (i, j) (rejected
        %> included)
        function dd = extract_datasets(o)
            if o.t < 10
                irwarning('Are you sure you want to extract datasets from estlog that has less than 10 confusion matrices?');
            end;
            [nr, nf, no] = size(o.hits);
            rl = o.get_rowlabels();
            C = o.get_C([], 1, 0);
            C = permute(C, [3, 2, 1]);
            for i = 1:nr
                d = irdata;
                d.X = C(:, :, i);
                d.title = ['Row ', int2str(i), ' - ', rl{i}];
                d.fea_x = 1:nf;
                d.fea_names = ['Rejected', o.get_collabels()];
                d = d.assert_fix();
                dd(i) = d;
            end;
        end;

        %> Each cell needs be a different dataset because number of supports (therefore dataset's @c no ) is different for each cell.
        %>
        %> @param ij (number of datasets)x(2) containing coordinates from the confusion matrix to extract supports from.
        %> Please note that j=1 is the "rejected" column, not the first colummn class.
        function dd = extract_datasets_sup(o, ij)
            nd = size(ij, 1);
            cl = o.get_collabels();
            rl = o.get_rowlabels();
            for id = 1:nd
                i = ij(id, 1);
                j = ij(id, 2);
                d = irdata;
                d.X = [o.supports{i, j, :}]';
                if j == 1
                    collabel = 'Rejected';
                else
                    collabel = cl{j-1};
                end;
                d.title = ['Supports ', rl{i}, '->', collabel];
                d.fea_x = 1;
                d.fea_names = {['Support ', rl{i}, '->', collabel]};
                d = d.assert_fix();
                dd(id) = d;
            end;
        end;

        %> Abstract. Classification rate, accuracy, performance or whatever.
        function z = get_rate(o)
            z = 0;
        end;
        
        %> Abstract. Classification rate vector calculated time-wise.
        function z = get_rates(o)
            z = zeros(1, size(o.hits, 3));
        end;

        function oc = extract_confusion(o)
            oc = o.get_confusion([], 1, 3);
        end;
        
        %> Whether the values returned by get_rate() and get_rates() are percentages or not. Returns TRUE
        function z = get_flag_perc(o)
            z = 1;
        end;
        
        function  z = get_unit(o)
            z = '%';
        end;
    end;
end
