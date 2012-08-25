%> @brief Blocks that operate on blocks
%>
%> Developers: Note that if you are considering inheriting this class to extract something from the block which does not needs a
%parameters GUI, you can use the
%> irobj::moreactions functionality.
classdef blbl < block;
    methods
        function o = blbl(o)
            o.classtitle = 'Block Operator';
        end;
    end;
end