%>@ingroup maths tentative
%>@file
%>@brief Calculates the correlations between each variable and the "optimal score"[1]
%>
%> <h3>Reference</h3>
%> [1] Hastie et al., The elements of statistical learning (2007), 2nd ed.
%>
%> @param X "Predictor" variables
%> @param classes
%> @param nf_select Number of variables to be calculated.
%> @return <code>[loadings]</code> or <code>[loadings, scores]</code>
function v = feasel_corr(data, nf_select)

if ~exist('nf_select', 'var')
    nf_select = 1;
end;

% Step 0 - standardizes dataset
ostd = pre_norm_std();
data = ostd.use(data);

% Step 1 - calculates the "optimal scores"
ofcon = fcon_lda();
ofcon.max_loadings = 1;
ofcon = ofcon.boot();
ofcon = ofcon.train(data);
dslda = ofcon.use(data);

% Step 2 - creates a Y vector with the optimal scores instead of classes
Y = zeros(data.no, 1);
for i = 1:data.nc
    boolvec = dslda.classes == i-1;
    Y(boolvec) = mean(dslda.X(boolvec, 1));
end;

% Step 3 - stepwise selection
X = data.X;
nf = data.nf;

v = [];
ii = 1:nf;
for m = 1:nf_select
    % Coefficients are correlations between X and Y
    cc = X'*Y;
    [value, index] = max(cc); %#ok<ASGLU>
    
    v(end+1) = ii(index);
    
    z = X(:, index);
    X(:, index) = [];
    ii(index) = [];
    nf = nf-1;
    
    % Makes columns in X orthogonal to the selected feature.

    for j = 1:nf
        X(:, j) = X(:, j)-z*(z'*X(:, j)/(z'*z));
    end;
end;

