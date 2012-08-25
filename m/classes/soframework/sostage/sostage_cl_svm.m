%> @brief sostage - Classification k-NN
%>
%>
classdef sostage_cl_svm < sostage_cl
    properties
        %> SVM's C
        c;
        %> SVM's gamma
        gamma;
    end;

    methods(Access=protected)
        function out = do_get_base(o)
            out = clssr_svm();
            out.flag_weighted = o.flag_cb;
            out.c = o.c;
            out.gamma = o.gamma;
        end;
    end;
    
    methods
        %> Constructor
        function o = sostage_cl_svm()
            o.title = 'SVM';
            o.flag_cbable = 1;
        end;
    end;
end
