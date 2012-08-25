%> Shortcut to a block-cascade containing a PCA and an LDA
%>
%> @sa uip_cascade_pcalda.m
classdef cascade_pcalda < block_cascade_base
    properties(Dependent)
        flag_rotate_factors = 1;
        no_factors = 10;
        flag_sphere = 0;
        flag_modified_s_b = 0;
        penalty = 0;
        max_loadings;
    end;
    
    methods
        function o = cascade_pcalda(o)
            o.classtitle = 'PCA-LDA';
            o.flag_trainable = 1;
            o.blocks = {fcon_pca(), fcon_lda()};
        end;

        function x =  get.flag_rotate_factors(o)
            x = o.blocks{1}.flag_rotate_factors;
        end;
        function o = set.flag_rotate_factors(o, x)
            o.blocks{1}.flag_rotate_factors = x;
        end;
        

        
        
        function o = set.no_factors(o, x)
            o.blocks{1}.no_factors = x;
        end;
        function x =  get.no_factors(o)
            x = o.blocks{1}.no_factors;
        end;

        
        
        
        
        function x =  get.flag_modified_s_b(o)
            x = o.blocks{2}.flag_modified_s_b;
        end;
        function o = set.flag_modified_s_b(o, x)
            o.blocks{2}.flag_modified_s_b = x;
        end;
        
        

        
        
        function x =  get.flag_sphere(o)
            x = o.blocks{2}.flag_sphere;
        end;
        function o = set.flag_sphere(o, x)
            o.blocks{2}.flag_sphere = x;
        end;

        
        

        function x =  get.penalty(o)
            x = o.blocks{2}.penalty;
        end;
        function o = set.penalty(o, x)
            o.blocks{2}.penalty = x;
        end;
    
    
        function x =  get.max_loadings(o)
            x = o.blocks{2}.max_loadings;
        end;
        function o = set.max_loadings(o, x)
            o.blocks{2}.max_loadings = x;
        end;
    end;
    
end