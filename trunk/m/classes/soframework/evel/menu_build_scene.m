%> This script depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
scenesetup;

while 1
    option = menu(sprintf('Building menu for scene "%s"', a.scenename), ...
        {'Build everything', ...
         'Build tasks in database only', ...
         'Generate M files only', ...
         'Create dataset splits only', ...
         'Delete existing tasks', ...
        }, 'Cancel', 0);
    switch option
        case 1
            a.go();
        case 2
            a.write_database();
        case 3
            a.save_files();
        case 4
            a.create_datasplits();
        case 5
            a.delete_tasks();
        case 0
            break;
    end;
end;


