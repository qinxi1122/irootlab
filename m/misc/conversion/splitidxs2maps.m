%> @ingroup conversion classlabelsgroup
%> @file
%> @brief Converts splitidxs to cell of maps
%>
%> @todo who uses this? classsplitter?
%
%>@param splitidxs from @ref irdata
%>@return \em maps
function maps = splitidxs2maps(splitidxs)
maximus = max(splitidxs);

imap = 0;
for ima = 0:maximus
    tarumba = find(splitidxs == ima);
    if ~isempty(tarumba)
        imap = imap+1;
        maps{imap} = tarumba;
    end;
end;
