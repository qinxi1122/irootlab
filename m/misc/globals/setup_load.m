%> @file
%> @ingroup globals setupgroup
%> @brief Loads file irootsetup.m if exists.
function setup_load()
verbose_assert();
db_assert();
fig_assert();
path_assert();
more_assert();

if exist('irootsetup.m', 'file');
    irootsetup;
end;
