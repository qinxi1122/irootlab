%>@file
%>@ingroup demo
%>@brief OBSOLETE Example of @ref bmtable - quick analysis

% Initialization
fig_assert;
global FONTSIZE;
FONTSIZE = 20;




%%%%%%%%% Dataset
ds01 = load_data_she5trays;

pieces = data_split_classes(ds01, 1); % Splits by tray. Each piece will have two classes: Non-transformed vs Transformed
for i = 1:numel(pieces)
    pieces(i).X = normaliz(pieces(i).X, [], 's');
    pieces(i).title = ['Chemical ', pieces(i).classlabels{1}(1)];
end;



%%%%%%%%% FOUR DIFFERENT METHODS ...



%%%%% ... 11111 PCA-LDA ...
o = cascade_pcalda();
o = o.setbatch({'no_factors', 10, ...
'flag_rotate_factors', 0, ...
'penalty', 0});
cascade_pcalda01 = o;




%%%%%% ... 22222 t-test ...
o = fsg_test_t();
fsg_test_t01 = o;

o = as_fsel_grades_fsg();
o = o.setbatch({'type', 'nf', ...
'nf_select', 10, ...
'threshold', -log10(0.05), ...
'peakdetector', [], ...
'fsg', fsg_test_t01});
as_fsel_grades_fsg01 = o;




%%%%%% ... 33333 LDA only ...
fcon_lda01 = fcon_lda();



%%%%%% ... 44444 PLS ...

% PLS block has a decimation block before, just to show that bmtable is able to assimilate cases when
% different blocks have different grade_x
fcon_pls01 = fcon_pls();
cascade_pls = block_cascade_base();
cascade_pls.blocks = {fcon_decimate(), fcon_pls01};
% fcon_pls01.flag_autostd = 1;




%%%%%% The peak detector
o = peakdetector();
o = o.setbatch({'flag_perc', 1, ...
'flag_abs', 1, ...
'minaltitude', 0, ...
'minheight', 0, ...
'mindist', 3, ...
'no_max', 6});
peakdetector01 = o;



%%%%%% The bmtable
bm = bmtable();
bm.blocks = {cascade_pcalda01, fcon_lda01, cascade_pls, as_fsel_grades_fsg01};
bm.datasets = num2cell(pieces);
bm.peakdetectors = {peakdetector01};
bm.arts = {bmart_circle, bmart_pentagram, bmart_diamond, bmart_square};
bm.units = {bmunit_au, bmunit_int}; % au for pca-lda loadings and t-test; int for the histogram
bm.data_hint = ds01;
bm.rowname_type = 'dataset';
bm.sig_j = [4, 4, 4, 4];
bm.sig_threshold = -log10(0.025);
iunits = [1, 1, 1, 1];

% Set up the grid
for idata = 1:length(pieces)
    
    for iblock = 1:numel(bm.blocks)
        bm.grid{idata, iblock} = setbatch(struct(), {'i_block', iblock, 'i_dataset', idata, 'i_peakdetector', 1, 'i_art', ...
            iblock, 'i_unit', iunits(iblock), 'params', {'flag_abs', iblock == 2}, 'flag_sig', iblock == 2});
    end;
    
end;

%-%
bm = bm.go();
%-%
figure;
bm = bm.draw_pl();
%-%
figure;
bm = bm.calc_cols();
bm = bm.draw_lines(1);

