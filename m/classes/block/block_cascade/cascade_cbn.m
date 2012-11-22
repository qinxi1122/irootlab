%> @brief Cascade: fsel -> pre_bc_rubber -> pre_norm_amide1
classdef cascade_cbn < block_cascade_base
    methods
        function o = cascade_cbn()
            o.classtitle = 'Cut->RubberBC->AmideI Normalization';
            o.flag_trainable = 0;
            o.blocks = {fsel(), pre_bc_rubber(), pre_norm_amide1()};
        end;
    end;
end