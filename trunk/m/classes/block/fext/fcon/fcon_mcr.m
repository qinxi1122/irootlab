%> Multivariate Curve Resolution
%>
%> Uses the Toolbox from the University of Barcelona (http://www.mcrals.info)
%>
%> Not completely developed, I couldn't find out how to find a good guess of initial loadings.
%> It has been used in one Imran's publication nonetheless. There is a document file that shows how to answer the
%> iterative questions (case when Number of Factors is 10): <a href="mcr.pdf">mcr.pdf</a>
%>
%> @sa uip_fcon_mcr.m
classdef fcon_mcr < fcon_linear
    properties
        flag_rotate_factors = 1;
        no_factors = 10;
    end;
    
    methods
        function o = fcon_mcr(o)
            o.classtitle = 'MCR - Multivariate Curve Resolution';
            o.flag_trainable = 0;
        end;
    end;
    
    methods(Access=protected)
               
        function [o, out] = do_use(o, data)

            % Uses PCA for guess of initial "spectra", but not recommended.
            opca = fcon_pca();
            opca = opca.setbatch({'no_factors', opca.no_factors, ...
            'flag_rotate_factors', 0});
            opca = opca.train(data);

            nfact = size(opca.L, 2);
            [copt,sopt,sdopt,ropt,areaopt,rtopt]=als(data.X, abs(opca.L'), 1, 50, 0.0001, ones(1, nfact), 0, 0, [], []);

            o.L = adjust_unitnorm(sopt');
            
            out = data;
            out.X = copt;
            out.fea_x = 1:size(copt, 2);
        end;
    end;
end