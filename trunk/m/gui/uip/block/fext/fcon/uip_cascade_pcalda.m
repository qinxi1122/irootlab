%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref cascade_pcalda
%>
%> <p>@image html Screenshot-uip_fcon_pca.png</p>
%>
%> <p>@image html Screenshot-uip_fcon_lda.png</p>
%>
%> @brief Properties Setup Dialogs for @ref cascade_pcalda
%>
%> @sa cascade_pcalda, uip_fcon_pca.m, uip_fcon_lda.m

%>@cond
function z = uip_cascade_pcalda(varargin)

z.flag_ok = 0;
z1 = uip_fcon_pca(varargin{:});
if z1.flag_ok
    z2 = uip_fcon_lda(varargin{:});
    if z2.flag_ok
        z = z1;
        z.params = [z.params, z2.params];
    end;
end;
%>@endcond
