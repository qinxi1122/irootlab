%>
%>
%> <ul>
%>   <li>Creates files:
%>     <ul>
%>       <li> sosetup_scene.m</li>
%>       <li> dataloader_scene.m</li>
%>     </ul></li>
%>   <li>Creates data splits</li>
classdef scenebuilder
    properties
        %> Filename of the base dataset
        filename = [];
        
        %> classlabel of the reference class (e.g. "control"). Must be provided if the dataset has 3 classes or more.
        reflabel = [];
        
        %> There is no default (has to be set otherwise go() will give error)
        scenename = [];
        
        %> List of "wrapper" classifiers (ones without embedded feature selection)
        %> @sa taskadder for more information
        clwrapper = {'ldc', 'qdc', 'knn'};
        
        %> List of classifiers with embedded feature selection.
        %> @sa taskadder for more information
        clembedded = {'lasso'};
        
        %> List of feature extraction methods.
        %> @sa taskadder for more information
        fe = {'pca', 'pls', 'ffs', 'manova', 'fisher', 'spline', 'lasso'};
        
        %> Stabilizations that will be put in practice
        %> @sa taskadder for more information
        fhg_stab = [0, 2, 5, 10, 20];
        
        %> List of classifiers to use with fhg_ffs
        %> @sa taskadder for more information
        fhg_ffs_cl = {'ldc', 'qdc', 'knn'};
        %> List of other FHG's to run (apart from fhg_ffs)
        %> @sa taskadder for more information
        fhg_others = {'lasso', 'manova', 'fisher'};
    end;
    
    properties(SetAccess=protected)
        %> number of classes of base dataset
        nc;

        %> Whether boot() has been called
        flag_booted = 0;
    end;
    
    
    
    
    methods
        function o = check_booted(o)
            if ~o.flag_booted
                irerror('Call boot() first!');
            end;
        end;
        
        function o = assert_booted(o)
            if ~o.flag_booted()
                o = o.boot();
            end;
        end;
        
        function o = boot(o)
            if isempty(o.scenename)
                irerror('Please provide a name for the scene');
            end;
            
            if isempty(o.filename)
                irerror('Please provide data file name!');
            end;

            
            % finds out the number of classes of the dataset in case
            ds = dataloader.load_dataset(o.filename); % static dataloader method
            o.nc = ds.nc;
            
            if o.nc > 2
                if isempty(o.reflabel)
                    irerror('Dataset has more than 2 classes, reference class must be provided!');
                end;
                
                
                refindex = find(strcmp(ds.classlabels, o.reflabel)); %#ok<EFIND>
                if isempty(refindex)
                    irerror(sprintf('Dataset does not have the reference class "%s"!', o.reflabel));
                end;

            end;
        end;
    end;
    
    
    

    
    methods
        function o = go(o)
            o = o.assert_booted();

            o = o.check_protection();
            o = o.save_files();
            o = o.create_datasplits();
            o = o.write_database();
            
        end;
    end;
    
    
    

    
    
    
    methods
        function o = check_protection(o)
            if exist('protection.m', 'file');
                protection();
                
                if ~flag_allow_overwrite
                    irerror('Scene is already created! Change protection.m to allow overwrite.');
                end;
            end;
        end;
        
        
        %> Saves files
        %>
        %> The files 'protection.m' and 'sosetup_scene.m' are only created if they don't exist yet.
        %> Makes sense, since the first is a control file to further build attempts, and the second has is insensitive to properties from this class.
        %>
        %> @param tosave [no_files]x[2] cell. 1st column is filename; 2nd column is the file contents
        function o = save_files(o)
            tosave = {'dataloader_scene.m', o.get_s_dataloader_scene_m();
                      'run_tasks.m', o.get_s_run_tasks_m();
                     };
                 
            if ~exist('protection.m', 'file')
                tosave(end+1, :) = {'protection.m', o.get_s_protection_m()};
            end;
            
            if ~exist('sosetup_scene.m', 'file')
                tosave(end+1, :) = {'sosetup_scene.m', o.get_s_sosetup_scene_m()};
            end;
                 
                 
            n = size(tosave, 1);
 
            % Deletes files
            for i = 1:n
                if exist(tosave{i, 1}, 'file');
                    delete(tosave{i, 1});
                end;
            end;
                
                 
            for i = 1:n
                h = fopen(tosave{i, 1}, 'w');
                fwrite(h, tosave{i, 2});
                fclose(h);
                irverbose(sprintf('Wrote file "%s"', tosave{i, 1}));
            end;
            
            o = o.save_setup();
        end;
        
        %> Saves irootlab_setup.m to point to pre-determined database
        function o = save_setup(o)
            setup_load();
            db_assert();
            global DB;
            DB.host = 'bioph.lancs.ac.uk';
            DB.name = 'taskman';
            DB.user = 'taskman_user';
            DB.pass = 'adamondra';
            setup_write();
        end;

        %> Uses newly created dataloader_scene class to create data splits
        function o = create_datasplits(o)
            rehash('path'); % I think this is neede but not sure
            oo = sosetup_scene();
            obj = dataloader_scene();
            obj.flag_group = oo.cubeprovider.flag_group;
            obj.create_splits();
        end;
            
        
        

        
        function flag = create_scene(o)
            flag = 0;
            a = mym('select id from task_scene where name = "{S}"', o.scenename);
            if isempty(a.id)
                mym('insert into task_scene (name) values ("{S}")', o.scenename);
                flag = 1;
            end;
        end
    end;

    
    methods
        function o = write_database(o)
            setup_load();
            assert_connected_to_cells();
            
            
            o.create_scene();
            
            tm = taskmanager();
            tm.scenename = o.scenename;
            tm = tm.boot();

            ta = taskadder();
            ta.tm = tm;
            ta.clwrapper = o.clwrapper;
            ta.clembedded = o.clembedded;
            ta.fe = o.fe;
            ta.fhg_stab = o.fhg_stab;
            ta.fhg_ffs_cl = o.fhg_ffs_cl;
            ta.fhg_others = o.fhg_others;
            ta.go();
        end
    end;
    
    
    %>>>>>>
    %>>>>>> MATLAB code generation
    %>>>>>>
    
    methods % Don't need to be protected, they are just getters
        %> Returns string for sosetup_scene.m file
        function s = get_s_sosetup_scene_m(o) %#ok<*MANU>
            s = [ ...
'% File automatically generated by scenebuilder', 10, ...
'function o = sosetup_scene()', 10, ...
'o = sosetup();', 10, ...
'o.dataloader = dataloader_scene();', 10, ...
'o.subdatasetprovider.randomseed = ', int2str(randi(1e9)), '; % Arbitrary random numbers', 10, ...
'o.cubeprovider.randomseed = ', int2str(randi(1e9)), ';', 10, ...
'o.under_randomseed = ', int2str(randi(1e9)), ';', 10, ...
];
        end;
        
        %> Returns string for dataloader_scene.m file
        function s = get_s_dataloader_scene_m(o)
            s = [ ...
'% File automatically generated by scenebuilder', 10, ...
'function o = dataloader_scene()', 10, ...
'o = dataloader();', 10, ...
'o.title = ''', o.scenename, ''';', 10, ...
'o.reflabel = ''', o.reflabel, ''';', 10, ...
'o.randomseed = ', int2str(randi(1e9)), ';', 10, ...
'o.basefilename = ''', o.filename, ''';',  10, ...
];
        end;
        
        
        %> Returns string for run_tasks.m file
        function s = get_s_run_tasks_m(o)
            s = [ ...
'% File automatically generated by scenebuilder', 10, ...
'% This function is suitable for being compiled', 10, ...
'function run_tasks()', 10, ...
'classcreator(); % Mentions the required files so that mcc compiles them together', 10, ...
'setup_load();', 10, ...
'assert_connected_to_cells();', 10, ...
'tm = taskmanager();', 10, ...
'tm.scenename = ''', o.scenename, ''';', 10, ...
'tm = tm.boot();', 10, ...
'[o, idxs] = tm.run_until_all_gone();', 10, ...
'fprintf(''Idxs run:\n%s\n'', mat2str(idxs));', 10, ...
];
        end;
        

        %> Returns string for protection.m file
        function s = get_s_protection_m(o)
            s = [ ...
'% Activate this flag to allow build_scene.m to redo everything', 10, ...
'flag_allow_overwrite = 0;', 10, ...
];
        end;
        
    end;
end