%> @ingroup ioio reinforcement
%> @file
%> Tests the mysql connection to the database. 
%>
%> If not connected, an error is thrown.
%>
%> Should be called "assert_connected()", but nevermind

function assure_connected()
status = irquery('status');
if status ~= 0
    irerror('Not connected to database!')
end
