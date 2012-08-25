%>@ingroup datasettools
%> @file
%> @brief Calculates the "cluster vectors"
%>
%> <h3>References</h3>
%> (1) Binary Mixture Effects by PBDE Congeners (47, 153, 183, or 209) and PCB Congeners (126 or 153) in MCF-7 Cells: 
%> Biochemical Alterations Assessed by IR Spectroscopy and Multivariate Analysis. Valon Llabjani, Julio Trevisan,
%> Kevin C. Jones, Richard F. Shore, Francis L. Martin. ES&T, 2010, 44 (10), 3992-3998.
%>
%> (2) Martin FL, German MJ, Wit E, et al. Identifying variables responsible for clustering in discriminant analysis of
%> data from infrared microspectroscopy of a biological sample. J. Comp. Biol. 2007; 14(9):1176-84.

%> @param data @ref irdata object.
%> @param L Loadings matrix
%> @param idx_class_origin Index of class to be considered the origin of the space (1). If <= 0, classical cluster
%> vectors will be calculated (2).
%>
%> @return \em cv Cluster vectors, dimensions [\ref nf]x[\ref nc]
function cv = data_get_cv(data, L, idx_class_origin)
if ~exist('idx_class_origin', 'var')
    idx_class_origin = 0;
end;

pieces = data_split_classes(data);

if idx_class_origin > 0
    v_shift = -(mean(pieces(idx_class_origin).X, 1)*L)';
else
    v_shift = 0;
end;

cv = zeros(data.nf, data.nc);
for k = 1:data.nc
    m = (mean(pieces(k).X, 1)*L)';
    cv(:, k) = L*(m+v_shift);
end;
