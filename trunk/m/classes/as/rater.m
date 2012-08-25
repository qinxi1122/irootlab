%> @brief "Rater" class
%>
%> This class makes simple the job evaluating a classifier performance through cross-validation. It fills in all
%> properties with default values, except from @c data:
%> @arg Default decider
%> @arg Default sgs
%> @arg Default ttlog
%> @arg Even default classifier
%>
%> Check the code below for the defaults:
%>@code
%> % Default classifier clssr_cla
%> z = clssr_cla();
%> 
%> % Default decider decider
%> z = decider();
%> % Default SGS 10-fold cross-validation
%> z = sgs_crossval();
%> z.no_reps = 10;
%> z.flag_group = 1;
%> z.randomseed = 0;
%> z.flag_perclass = 0;
%> 
%> % Default ttlog estlog_classxclass
%> z = estlog_classxclass();
%> z.estlabels = o.data.classlabels;
%> z.testlabels = z.estlabels;
%>@endcode
%>
%> A more complex (but complete) alternative is @ref reptt_sgs
%>
%> @sa uip_rater.m, demo_rater.m
classdef rater < as
    properties
        clssr;
        decider;
        sgs;
        ttlog;
        data;
    end;
    
    properties(SetAccess=protected)
        obsidxs;
        datasets;
        
        flag_sgs;
        %> Needs to check data?
        flag_check_data = 1;
        %> Needs to check others?
        %>
        %> Checking is separated into data and "others". Checking data is costly, whereas checking the "others" = {clssr, decider, sgs,
        %> ttlog} is not and can be done even if only one of them has been set.
        %>
        %> Please note that setting the "sgs" property will cause both flag_check_data and flag_check_others to be true, because setting SGS
        %> will affect the way the datasets will be generated
        flag_check_others = 1;
    end;
    

    methods
        function o = rater()
            o.classtitle = 'Rater';
            o.moreactions = {'go'};
        end;

        %> Returns the object with its ttlog ready to have its get_rate() called.
        function log = go(o)
            o = o.check_others();
            o = o.check_data();
            
            if o.flag_sgs
                no_reps = size(o.obsidxs, 1);
            
                log = o.ttlog.allocate(no_reps);
                ipro = progress2_open('RATER', [], 0, no_reps);
                for i = 1:no_reps
                    cl = o.clssr.boot();
                    cl = cl.train(o.datasets(i, 1));
                    est = cl.use(o.datasets(i, 2));
                    est = o.decider.use(est);

                    pars.dref = o.datasets(i, 2);
                    pars.est = est;
                    log = log.record(pars);
                    ipro = progress2_change(ipro, [], [], i);
                end;
                progress2_close(ipro);
            else
                log = o.ttlog.allocate(1);
                
                cl = o.clssr.boot();
                cl = cl.train(o.data(1));
                est = cl.use(o.data(2));
                est = o.decider.use(est);

                pars.dref = o.data(2);
                pars.est = est;
                log = log.record(pars);
            end;
        end;
        
        function z = get_rate(o)
            o = o.go();
            z = o.ttlog.get_rate();
        end;
        
        function z = get_rate_with_clssr(o, x)
            o.clssr = x;
            log = o.go();
            z = log.get_rate();
        end;
    end;
    

    %------> Defaults
    methods
        function z = get_defaultdecider(o)
            irverbose('Rater is creating default decider decider', 2);
            z = decider(); %#ok<CPROP,PROP>
        end;
        
        function z = get_defaultsgs(o)
            irverbose('Rater is creating default SGS', 2);
            z = def_sgs();
        end;

        function z = get_defaultttlog(o)
            irverbose('Rater is creating default ttlog estlog_classxclass', 2);
            z = estlog_classxclass();
            z.estlabels = o.data(1).classlabels;
            z.testlabels = z.estlabels;
        end;
    end;

    
    methods(Access=protected)
        function o = check_others(o)
            o.flag_sgs = 1;
            if isempty(o.sgs) 
                if numel(o.data) == 1
                    o.sgs = o.get_defaultsgs();
                else
                    o.flag_sgs = 0;
                end;
            end;
            
            o.clssr = def_clssr(o.clssr);

            if isempty(o.decider)
                o.decider = o.get_defaultdecider();
            end;
            
            if isempty(o.ttlog)
                o.ttlog = o.get_defaultttlog();
            end;
            
            o.flag_check_others = 0;
        end;
        
        function o = check_data(o)
            if o.flag_sgs
                o.obsidxs = o.sgs.get_obsidxs(o.data);
                o.datasets = o.data.split_map(o.obsidxs(:, [1, 2]));
            end;

            o.flag_check_data = 0;
        end;
        
        function s = do_get_html(o)
            s = [];
            if ~isempty(o.ttlog)
                pars.flag_individual = 0;
                s = cat(2, s, '<h2>ttlog''s HTML</h2>', 10, o.ttlog.get_insane_html(pars));
            end; 

            s = cat(2, s, do_get_html@as(o));
        end;
    end;
end