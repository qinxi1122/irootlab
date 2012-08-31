%> @file
%> @ingroup soframework
%> @brief Creates tasks in database using the taskmanager object passed
classdef taskadder
    properties
        %> taskmanager object
        tm;

        %> List of "wrapper" classifiers (ones without embedded feature selection)
        %> Classnames:
        %>   @arg goer_clarchsel__<clwrapper{i}>
        %>
        %> @note the list in @fhg_ffs_cl will be united with this one, as FHG requires the CLARCHSEL step
        %> 
        %> @sa @ref fe and @ref fhgstab properties
        clwrapper = {'ldc', 'qdc', 'knn'};
        
        %> List of classifiers with embedded feature selection.
        %> Classnames:
        %>   @arg goer_clarchsel__<clembedded{i}>
        %>   @arg goer_fhg__<clembedded{i}>__stab00
        %>   @arg goer_undersel____<clembedded{i}>
        clembedded = {'lasso'};
        
        %> List of feature extraction methods.
        %> Classnames:
        %>   @arg goer_fe__<fe{i}>__<clwrapper{j}>
        %>   @arg goer_undersel__<fe{i}>__<clwrapper{j}>
        fe = {'pca', 'pls', 'ffs', 'manova', 'fisher', 'spline', 'lasso'};
        
        %> Stabilizations that will be put in practice
        %>
        %> @sa fhg_ffs_cl
        fhg_stab = [0, 2, 5, 10, 20];
        
        %> List of classifiers to use with fhg_ffs
        %> Classnames:
        %>   @arg goer_fhg__ffs__<fhg_ffs_cl{i}>__stab<fhg_stab(j)>
        fhg_ffs_cl = {'ldc', 'qdc', 'knn'};
        %> List of other FHG's to run (apart from fhg_ffs)
        %> Classnames:
        %>   @arg goer_fhg__<fhg_others{i}>__stab00
        fhg_others = {'lasso', 'manova', 'fisher'};
    end;
    
    properties(SetAccess=protected)
        flag_booted = 0;
        %> Cross-validation's "k"
        k;
        %> Number of classes of base dataset
        nc;
    end;
    
    methods
        function o = boot(o)
            
            o.tm = o.tm.boot();
            
            dl = dataloader_scene();
    
            ds = dl.get_basedataset();
            o.nc = ds.nc;
            
            o.k = dl.k; % Cross-validation's "k"

            o.flag_booted = 1;
        end;
        
        
        %> Creates all the tasks
        function o = go(o)
            o = o.boot();
            
            o.tm = o.tm.delete_tasks();
            
            try
                o = o.add_all();
                o.tm = o.tm.commit_tasks();
            catch ME
%                 o.tm = o.tm.commit_tasks();
                rethrow(ME);
            end;
        end;
    end;
    
    
    methods(Access=protected)
        function o = add_all(o)
            clwrapper_eff = union(o.clwrapper, o.fhg_ffs_cl);
            
            no_clwrapper_eff = numel(clwrapper_eff);
            no_clembedded = numel(o.clembedded);
%             no_fe = numel(o.fe);
            no_fhg_stab = numel(o.fhg_stab);
            no_fhg_others = numel(o.fhg_others);
            
            
            for i = 0:iif(o.nc > 2, o.nc-1, 0) % One-versus-reference (OVR) index
                
                fe_now = o.fe;
                if i == 0 && o.nc > 2
                    fe_now(strcmp(fe_now, 'lasso')) = []; % Ok I know that this is a hack, but easy fix and can be easily made general
                end;
                no_fe = numel(fe_now);
                
                %-----> Distribution
%                 nfhg = 0;
                fhgtoken = {}; fn_fhgout = {}; idxfhgout = []; % Because the sizes of these may vary depending on "i"
                for j = 1:o.k % Cross-validation (CV) index
                    r = 0;
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        fn_clarchselout = sprintf('output_clarchsel__%s__ovr%02d_cv%02d.mat', scl, i, j);
                        [o.tm, idxarch] = o.tm.add_task(sprintf('goer_clarchsel__%s', scl), '', fn_clarchselout, i, j, [], -1);
                        for n = 1:no_fe
                            sfe = fe_now{n};
                            fn_fearchselout = sprintf('output_fearchsel__%s__%s__ovr%02d_cv%02d.mat', sfe, scl, i, j);
                            fn_undersel{j, m, n} = sprintf('output_undersel__%s__%s__ovr%02d_cv%02d.mat', sfe, scl, i, j);
                            
                            [o.tm, idxfearchsel] = o.tm.add_task(sprintf('goer_fearchsel__%s__%s', sfe, scl), fn_clarchselout, fn_fearchselout, ...
                                i, j, idxarch, -1);
                            [o.tm, idxundersel(j, m, n)] = o.tm.add_task(sprintf('goer_undersel__%s__%s', sfe, scl), fn_fearchselout, ...
                                fn_undersel{j, m, n}, i, j, idxfearchsel, -1);
                        end;
                        
                        if ismember(scl, o.fhg_ffs_cl)
                            for q = 1:no_fhg_stab
                                r = r+1;
                                if j == 1
                                    fhgtoken{r} = sprintf('ffs_%s__stab%02d', scl, o.fhg_stab(q)); % Needs this because I cannot construct suitable filenames at the merging phase otherwise
                                end;
                                fn_fhgout{j, r} = sprintf('output_fhg__ffs_%s__stab%02d__ovr%02d_cv%02d.mat', scl, o.fhg_stab(q), i, j);
                                [o.tm, idxfhgout(j, r)] = o.tm.add_task('goer_fhg_ffs', fn_clarchselout, fn_fhgout{j, r}, i, j, idxarch, ...
                                    o.fhg_stab(q));
                            end;
                        end;
                    end;
                    
                    for m = 1:no_clembedded
                        scl = o.clembedded{m};
                        fn_clarchselout = sprintf('output_clarchsel__%s__ovr%02d_cv%02d.mat', scl, i, j);
                        fn_undersel_em{j, m} = sprintf('output_undersel____%s__ovr%02d_cv%02d.mat', scl, i, j);
                        [o.tm, idxarch] = o.tm.add_task(sprintf('goer_clarchsel__%s', scl), '', fn_clarchselout, i, j, [], -1);
                        [o.tm, idxundersel_em(j, m)] = o.tm.add_task(sprintf('goer_undersel____%s', scl), fn_clarchselout, ...
                            fn_undersel_em{j, m}, i, j, idxarch, -1);
                    end;
                    
                    for q = 1:no_fhg_others
                        if ~(i == 0 && o.nc > 2 && get_flag_2class(o.fhg_others{q}))
                            r = r+1;
                            if j == 1
                                fhgtoken{r} = sprintf('%s', o.fhg_others{q});
                            end;
                            fn_fhgout{j, r} = sprintf('output_fhg__%s__ovr%02d_cv%02d.mat', o.fhg_others{q}, i, j);
                            [o.tm, idxfhgout(j, r)] = o.tm.add_task(sprintf('goer_fhg_%s', o.fhg_others{q}), '', fn_fhgout{j, r}, i, j, [], -1);
                        end;
                    end;
                end;
                
                %-----> Merging
                
                %--> Estimation of classification performance
                flag_pairwise = i == 0 && o.nc > 2;
                for p = 1:iif(flag_pairwise, 2, 1)
                    spa = iif(p == 1, 'np', 'pa');
                
                    % First concentrated the cross-validation results into single ones (FOLDMERGER)
                    fn_foldmerger_fitest = {};
                    idxfoldmerger_fitest = [];
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        for n = 1:no_fe
                            sfe = fe_now{n};
                            fn_foldmerger_fitest{m, n} = sprintf('output_foldmerger_fitest_%s__%s__%s__ovr%02d.mat', spa, sfe, scl, i);
                            [o.tm, idxfoldmerger_fitest(m, n)] = o.tm.add_task(['goer_foldmerger_fitest_', spa], fn_undersel(:, m, n), ...
                               fn_foldmerger_fitest{m, n}, i, 0, idxundersel(:, m, n), -1);
                        end;
                    end;

                    fn_foldmerger_fitest_em = {};
                    idxfoldmerger_fitest_em = [];
                    for m = 1:no_clembedded
                        scl = o.clembedded{m};
                        fn_foldmerger_fitest_em{m} = sprintf('output_foldmerger_fitest_%s____%s__ovr%02d.mat', spa, scl, i);
                        [o.tm, idxfoldmerger_fitest_em(m)] = o.tm.add_task(['goer_foldmerger_fitest_', spa], fn_undersel_em(:, m), ...
                            fn_foldmerger_fitest_em{m}, i, 0, squeeze(idxundersel_em(:, m)), -1);
                    end;
                    
                    % Now merges by classifier
                    for m = 1:no_clwrapper_eff
                        scl = clwrapper_eff{m};
                        fn_merger_fitest = sprintf('output_merger_fitest_%s____%s__ovr%02d.mat', spa, scl, i);
                        [o.tm, dummy] = o.tm.add_task('goer_merger_fitest', fn_foldmerger_fitest(m, :), fn_merger_fitest, i, 0, ...
                            idxfoldmerger_fitest(m, :), -1);  %#ok<NASGU>
                    end;

                    % Now merges by FE
                    for n = 1:no_fe
                        % Note that embedded classifiers are added to the end for comparison
                        sfe = fe_now{n};
                        fn_merger_fitest = sprintf('output_merger_fitest_%s__%s____ovr%02d.mat', spa, sfe, i);
                        [o.tm, dummy] = o.tm.add_task('goer_merger_fitest', ...
                            [fn_foldmerger_fitest(:, n)', fn_foldmerger_fitest_em], ...
                            fn_merger_fitest, i, 0, ...
                            [idxfoldmerger_fitest(:, n)', idxfoldmerger_fitest_em], -1); %#ok<NASGU>
                    end;
                end;
                
                %--> FHG
                nfhg = numel(fhgtoken);
                if nfhg > 0 % total number of FHG cases
                    % First concentrated the cross-validation results into single ones (FOLDMERGER)
                    fn_foldmerger_fhg = {};
                    idxfoldmerger_fhg = [];
                    for m = 1:nfhg
                        token = fhgtoken{m};
                        fn_foldmerger_fhg{m} = sprintf('output_foldmerger_fhg__%s__ovr%02d.mat', token, i);
                        [o.tm, idxfoldmerger_fhg(m)] = o.tm.add_task('goer_foldmerger_fhg', fn_fhgout(:, m), fn_foldmerger_fhg{m}, i, 0, idxfhgout(:, m), -1);
                    end;

                    fn_merger_fhg = sprintf('output_merger_fhg__ovr%02d.mat', i);
                    [o.tm, dummy] = o.tm.add_task('goer_merger_fhg', fn_foldmerger_fhg, fn_merger_fhg, i, 0, idxfoldmerger_fhg, -1);  %#ok<NASGU>
                end;
            end;    
        end;
    end;
end
