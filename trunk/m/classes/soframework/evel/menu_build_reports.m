%> This function depends on a file called "scenesetup.m" which must create a scenebuilder variable called "a"
function menu_build_reports()
scenesetup;
a.boot();
r = reportbuilder();
while 1
    a.report_scene();
    r.print_status();
    option = menu(sprintf('Report building menu for scene "%s"', a.scenename), ...
        {'Run/Continue', ...
         'Reset', ...
        }, 'Cancel', 0);
    try
        switch option
            case 1
                r = r.go();
                if r.flag_finished
                    disp('Bye :)');
                    break;
                end;
            case 2
                if confirm()
                    r = r.reset();
                end;
            case 0
                break;
        end;
    catch ME
        % Displays error and goes back to menu
        fprintf(2, strrep(ME.getReport(), '%', '%%')); % displays in red
    end;        
end;

%------
function flag = confirm()
flag = strcmp(input('Please type "yes" to confirm: ', 's'), 'yes');