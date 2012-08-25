%> SODATAITEM to be used as input to a diacomp
classdef soitem_diacompin < soitem
    properties
        %> multiple diagnosis systems
        diaa;
        %> array of raxistata
        ax = raxisdata.empty();
    end;
end