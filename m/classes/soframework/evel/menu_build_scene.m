%> This script depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
scenesetup;

while 1
    option = menu(sprintf('Building menu for scene "%s"', a.scenename), ...
        {
         'Check tasks', ...
         'Build tasks in database only', ...
         'Generate M files only', ...
         'Create dataset splits only', ...
         'Build everything', ...
         'Delete existing tasks', ...
        }, 'Cancel', 0);
    switch option
        case 1
            a.check_tasks();
        case 2
            a.write_database();
        case 3
            a.save_files();
        case 4
            a.create_datasplits();
        case 5
            a.go();
        case 6
            if strcmp(input('Confirm this with a "Yes" ', 's'), 'Yes')
                a.delete_tasks();
            end;
        case 0
            break;
    end;
end;


