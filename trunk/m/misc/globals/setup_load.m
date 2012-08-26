%> @file
%> @ingroup globals setupgroup
%> @brief Loads file irootlab_setup.m if exists.
function setup_load()
verbose_assert();
db_assert();
fig_assert();
path_assert();
more_assert();

if exist('irootlab_setup.m', 'file')
    irootlab_setup;
elseif if exist('irootsetup.m', 'file') % Backward compatibility
    irootsetup;
end;
