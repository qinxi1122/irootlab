%> @brief Used to record a @ref ttlog based on test and estimation data
%>
%> The purpose is to provide objtool with a block that can be used to record a @ref ttlog based on
classdef logrecorder < as
    properties
        %> The classifier is used to get the class labels to make a default @ref estlog if the @ref logrecorder::ttlog is not passed
        clssr;
        %> @ref ttlog object
        ttlog;
        %> (Optional) Block to post-process the test data.
        postpr_test;
        %> Block to post-process the estimation issued by the classifier.
        postpr_est;
    end;

    methods
        function o = logrecorder()
            o.classtitle = 'Log recorder';
            o.inputclass = 'estimato';
        end;

        %> Returns the object with its ttlog ready to have its get_rate() called.
        function [o, out] = do_use(o, est)
            if isempty(o.ttlog)
                if isempty(o.clssr)
                    irerror('Cannot create default ttlog, needs classlabels from clssr!');
                end;
                irverbose('Logrecorder is creating default ttlog estlog_classxclass', 2);
                z = estlog_classxclass();
                z.estlabels = o.clssr.classlabels;
                z.testlabels = z.estlabels;
                z = z.allocate(1);
                o.ttlog = z;
            end;
            
            if ~isempty(o.postpr_test)
                ds_test = o.postpr_test.use(o.ds_test);
            else
                ds_test = o.ds_test;
            end;
            if ~isempty(o.postpr_est)
                est = o.postpr_est.use(est);
            end;
            
            pars.ds_test = ds_test;
            pars.est = est;
            pars.clssr = o.clssr;
            
            out = o.ttlog.record(pars);
        end;
    end;   
end