%> @ingroup conversion
%> @file
%> @brief Converts a cell of subsets into a matrix.
%>
%> If the subset size varies, fills in smaller subsets with NaN's
%>
%> subsets is e.g. log_fselrepeater::subsets
function out = subsets2matrix(subsets)
nsub = numel(subsets);
numelmax = max(cellfun(@numel, subsets));

out = NaN(nsub, numelmax);

for i = 1:nsub
    subset = subsets{i};
    out(i, 1:numel(subset)) = subset(:);
end;
