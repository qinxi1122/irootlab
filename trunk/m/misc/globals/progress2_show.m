%> @ingroup globals usercomm
%> @file
%> @brief Shows progress bars - no globals

function progress2_show(prgrss)

for ib = 1:numel(prgrss.bars)
    bar = prgrss.bars(ib);

    ela = toc(bar.tic);
    
    if isempty(bar.perc)
        perccalc = bar.i/(bar.n+realmin);
    else
        perccalc = bar.perc;
    end;
    
    proje = ela/perccalc;
    
    
    irverbose([prgrss.bars(ib).sid, '[', ((linspace(0, 1, 25) > perccalc)*3+43), ']', sprintf('%6.0fs/%ss - %6.2f%% %s', ela, ...
        iif(proje < Inf, sprintf('%6.0f', proje), '     ?'), perccalc*100, bar.title)], 3);
end;
