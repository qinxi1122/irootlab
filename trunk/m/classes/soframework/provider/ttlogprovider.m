%> @brief Provides cell of ttlog objects
%>
%> This was made into a class so that in eClass cases 
%>
%>
classdef ttlogprovider
    methods
        %> returns a cell array of ttlogs based on an input dataset
        %>
        %> This function returns 3 ttlogs: one to record the classification rate, another to record the training time, and another one to record the
        %> use time
        function ll = get_ttlogs(o, data)

            l1 = estlog_classxclass();
%             l1.title = 'Classification Rate';
            l1.estlabels = data.classlabels;
            l1.testlabels = data.classlabels;
            l1.title = 'rates';

            l2 = ttlog_props();
%             l2.title = 'Training time';
            l2.propnames = {'time_train'};
            l2.propunits = {'seconds'};
            l2.title = 'times1';

            l3 = ttlog_props();
%             l3.title = 'Test time';
            l3.propnames = {'time_use'};
            l3.propunits = {'seconds'};
            l3.title = 'times2';
            
            ll = {l1, l2, l3};
        end;
    end;
end
