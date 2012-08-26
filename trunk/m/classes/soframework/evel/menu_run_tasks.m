%> This script depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
scenesetup;
setup_load();
assert_connected_to_cells();
tm = taskmanager();
tm.scenename = a.scenename;
tm = tm.boot();
while 1
    option = menu(sprintf('Tasks runner for scene "%s"', tm.scenename), {'Run until all gone', 'Reset failed', 'Reset ongoing', 'Reset all'}, 'Cancel', 0);
    switch option
        case 1
    [o, idxs] = tm.run_until_all_gone();
    fprintf('Idxs run:\n%s\n', mat2str(idxs));
        case 2
            tm.reset_failed();
        case 3
            tm.reset_ongoing();
        case 4
            tm.reset_all();
        case 0
            break;
    end;
end;
