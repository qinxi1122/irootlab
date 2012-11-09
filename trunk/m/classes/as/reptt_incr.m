Would be good to honour

%> @file
%> @ingroup parallelgroup as needsrevision
%
%> @brief Incremental learning curve - to test incremental classifiers
%>
%> @todo needs revision because go() is not outputting a log, but I am not using this at the moment, so I left it for later.
%>
%> This Analysis Session aims to raise "Incremental learning curves" (ILC) for one or more classifiers. This aims at testing incremental
%> classifiers such as eClass
%>
%> ILC's are are direcly stored in a dataset. Each class of the dataset corresponds to a different classifier in the block_mold property.
%>
%> The @ref reptt_incr::data property needs to have two elements: <code>[train, test]</code>. The @c test element will be always used as-is.
%> The @ref train dataset will have its rows permuted using the @ref reptt_incr::sgs. If an SGS is not provided, the @ref train dataset
%> will be used only once.
%>
%> <h3>Usage</h3>
%> Set the reptt_incr::data, reptt_incr::block_mold, reptt_incr::log_mold, and reptt_incr::sgs properties as desired.
%>
%> The block_mold objects must be of class @ref clssr_incr
%>
%> Then, call the reptt_incr::go() method and wait :)//
%>
%> Results may be extracted by one or more of the following routines:
%> @arg reptt_incr::extract_dataset() returns one dataset per element in reptt_incr::log_mold
%>
%> @sa uip_reptt_incr.m, reptt, irlog, vis_scatter1d, demo_reptt_incr.m, rater
classdef reptt_incr < reptt
    properties
        %> SGS object. Needs to be a @ref sgs_randsub_base; bites will be ignored and overwritten with "[1]"; type will be overwritten with "simple"
        %> The following properties make a difference: no_reps; flag_group; flag_perclass; randomseed
        sgs;
        %> =0. Whether to parallelize the outer "reps" loop
        flag_parallel = 0;
        %> =1. Recording periodicity
        record_every = 1;
    end;
    
    properties(SetAccess=protected)
        obsidxs;
        ests;
    
        %> Cell of datasets: each corresponding to one element in reptt_incr::log_mold
        results;
    end;

    methods(Access=protected)
        %> Returns number of recordings based on internal setup
        %>
        %> Asks the first element in block_mold
        function nr = get_no_recordings(o)
            bl = o.block_mold{1};
            bl.record_every = o.record_every;
            nr = bl.get_no_recordings(o.data(1).no);
        end;
        
        %> Allocates result datasets
        %>
        %> Allocates datasets rather than logs. The datasets are sized with zeroes in their @c X and @c classes
        %>
        %> Dimensions are:
        %> @arg results: cell of datasets: (1)X(no_logs)
        %> @arg each dataset: X: (no_blocks*no_reps)X(number of recordings)
        %>
        %> The number of recordings is currently the number of elements in the training set (one recording is taken after one row is passed
        %> to the incremental-training classifier)
        %>
        %> @todo fill in results properly
        function o = allocate_results(o)
            no_reps = size(o.obsidxs, 1);
            nb = numel(o.block_mold);
            nl = numel(o.log_mold);
            
            if ~iscell(o.block_mold)
                bmold = {o.block_mold};
            else
                bmold = o.block_mold;
            end;
            
            if ~iscell(o.log_mold)
                lmold = {o.log_mold};
            else
                lmold = o.log_mold;
            end;

            nr = o.get_no_recordings();
            
            % model dataset
            d = irdata();
            d.fea_x = [(1:nr-1)*o.record_every o.data(1).no];
            d.xname = 'Number of training observations';
            d.xunit = '';
            d.yname = 'Performance';
            d.yunit = '';
            d.X(nb*no_reps, nr) = 0;
            d.classes(nb*no_reps, 1) = 0;                

            d.classlabels = cell(1, nb);
            for i = 1:nb
                d.classlabels{i} = bmold{i}.get_description();
                d.classes((1:no_reps)+(i-1)*no_reps) = i-1;
            end;
            
            o.results = cell(1, nl);
            
            for i = 1:nl
                o.results{i} = d;
                o.results{i}.title = ['Based on ', lmold{i}.get_description()];
                o.results{i}.yunit = iif(o.log_mold{i}.get_flag_perc(), '%', '');
            end;
        end;
    end;
    
    methods
        function o = reptt_incr()
            o.classtitle = 'Incremental';
            o.moreactions = [o.moreactions, {'extract_datasets'}];
            o.flag_ui = 0; % Not published in GUI
        end;

        %> Asserts that the SGS object is a randsub one
        function o = assert_randsub(o)
            if ~isempty(o.sgs) && ~isa(o.sgs, 'sgs_randsub_base')
                irerror('sgs property needs to be a sgs_randsub_base!');
            end;
        end;
        
        %> Asserts that the blocks in @ref block_mold are all clssr_incr
        function o = assert_clssr_incr(o)
            for i = 1:numel(o.block_mold)
                if ~isa(o.block_mold{i}, 'clssr_incr')
                    irerror('All classifiers must be of class "clssr_incr"!');
                end;
            end;
        end;
        

        %> Fills in the @ref results property
        function o = go(o)
            o.assert_clssr_incr();
            
            flag_sgs = ~isempty(o.sgs);
            if flag_sgs
                o.assert_randsub();
                sgs_ = o.sgs;
                sgs_.bites = 1;
                sgs_.type = 'simple';
                o.obsidxs = o.sgs.get_obsidxs(o.data(1));
                no_reps = size(o.obsidxs, 1);
%                 nt = size(o.obsidxs, 2)-1; % Number of test datasets
            else
                no_reps = 1;
%                 nt = numel(o.data)-1;
            end;

            o = o.allocate_results();
%             o = o.allocate_blocks();

            nb = numel(o.block_mold);
            nl = numel(o.results);
            no_recordings = o.get_no_recordings();

            
            % Will have to split the dataset before the parfor!
            if ~flag_sgs
                dd = o.data(1);
            else
                dd = o.data(1).split_map(o.obsidxs);
            end;
            
            % Have to extrude everything from "o" that will be used by the workers
            o_blocks = o.block_mold;
            o_data2 = o.data(2);
            o_postpr_est = o.postpr_est;
            o_postpr_test = o.postpr_test;
            o_logs = o.log_mold;
            o_record_every = o.record_every;

            
            % Results assigned during the parallel loop
            tempresult = cell(1, no_reps*nb);

            if o.flag_parallel
                parallel_assert();
                parallel_open();
            end;
                       
            try
                t = tic();
            
                
                
                parfor i_par = 1:no_reps*nb
                    
                    i_rep = ceil(i_par/nb);
                    i_blk = mod(i_par-1, nb)+1;

%                     tempx = zeros(nl, no_recordings, nb);

%                     ipro = progress2_open('REPTT_INCR BLOCKS', [], 0, nb);
%                     for i_blk = 1:nb
                        bl = o_blocks{i_blk};

                        bl.data_test = o_data2;
                        bl.postpr_test = o_postpr_test;
                        bl.postpr_est = o_postpr_est;
                        bl.log_mold = o_logs;
                        bl.flag_rtrecord = 1;
                        bl.record_every = o_record_every;

                        bl = bl.boot();
%                         bl = bl.allocate(dd(i_rep).no); % dd(i_rep).no for all i_rep should be the same

                        bl = bl.train(dd(i_rep));

                        tempresult{i_par} = bl.rates;
%                         ipro = progress2_change(ipro, [], [], i_blk);
%                     end;
%                     progress2_close(ipro);


%                     tempresult{i_par} = tempx;
                end;

                irverbose(sprintf('TOTAL REPTT_INCR ELLAPSED TIME: %g\n', toc(t)));
                
                if o.flag_parallel
                    parallel_close();
                end;
            catch ME
                if o.flag_parallel
                    parallel_close();
                end;
                rethrow(ME);
            end;

            
            
            % Places results inside the right slots
            for il = 1:nl
                mult = iif(o.log_mold{il}.get_flag_perc(), 100, 1);
                for i_par = 1:no_reps*nb
                    
                    i_rep = ceil(i_par/nb);
                    i_blk = mod(i_par-1, nb)+1;
                    
                    o.results{il}.X(i_rep+(i_blk-1)*no_reps, :) = tempresult{i_par}(il, :)*mult;
                end;
            end;
        end;

        %> Generates as many datasets as elements in the @c log_mold property.
        %>
        %> @sa reptt_incr::allocate_logs()
        function out = extract_datasets(o)
            out = o.results;
        end;

    end;
end
