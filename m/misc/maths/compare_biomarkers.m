%> Similar to Jaccard's Index numel(intersect(A, B))/numel(union(A, B)), as without the fuzzy matching and weighting, it would read as
%> intersect(A, B)/max(numel(A), numel(B))

%> @param A First set of wavenumbers
%> @param B Second set of wavenumbers
%> @param WA (Optional) Weights of first set of wavenumbers. If not supplied or supplied as "[]", all weights will be considered the same. The weight scale is irrelevant.
%> @param WB (Optional) Weights of second set of wavenumbers. If not supplied or supplied as "[]", all weights will be considered the same. The weight scale is irrelevant.
%> @param hh =15. "half-height" distance between biomarkers. This is the distance in x-values (wavenumbers) where the degree of agreement
%>           will be considered to be 50%
%>
%> @return [matches, finalindex] the "matches" structure has the following fields:
%>   @arg @c .indexes 2-element vector containing the indexes of the originals
%>   @arg @c .wns 2-element vector containing the x-positions (wavenumbers/"wns") of the corresponding indexes
%>   @arg @c .agreement Result of the agreement calculation using the sigmoit function
%>   @arg @c .weight Average between the (normalized) weights of the matched positions
%>   @arg @c .strength Just the result of <code>agreement*weight</code>
%> The "agreement" will be calculated by a logistic sigmoid function (that of shape 1/(1+exp(x)))
function [matches, finalindex] = compare_biomarkers(A, B, WA, WB, hh)

% Parameters check and adjustments
if nargin < 3 || isempty(WA)
    WA = ones(1, numel(A));
end;
if nargin < 4 || isempty(WB)
    WB = ones(1, numel(B));
end;
if nargin < 5
    hh = 15;
end;

% Determines some sizes
nA = length(A);
nB = length(B);
nmin = min([nA, nB]);
nmax = max([nA, nB]);

% Working variables
D = pdist2(A(:), B(:)); %Distance matrix
idxs1 = 1:nA; % Needs to record indexes because these vectors will be reduced as elements are found
idxs2 = 1:nB;

sigfun0 = sigfun(0); % Small correction factor, because sigfun(0) = .9975 instead of 1

for i = 1:nmin
    % Finds row and column of minimum distance
    [val, idx0] = min(D(:)); %#ok<ASGLU>
    idx0 = idx0-1; % makes 0-based
    row = mod(idx0, nA)+1;
    col = floor(idx0/nA)+1;
    
    b.indexes = [idxs1(row), idxs2(col)];
    b.wns = [A(idxs1(row)), B(idxs2(col))];
    b.agreement = sigfun(D(row, col), hh)/sigfun0;
    b.weight = mean([WA(idxs1(row)), WB(idxs2(col))]);
%     b.weight = sqrt(WA(idxs1(row))*WB(idxs2(col))); % Geometric mean
    b.strength = b.agreement*b.weight;

    matches(i) = b; %#ok<AGROW>

    % Reduces working variables
    D(row, :) = [];
    D(:, col) = [];
    idxs1(row) = [];
    idxs2(col) = [];
    nA = nA-1;
end;

% Note that if n < nmax, some biomarkers will remain unmatched and the maximum final index will be n/nmax

finalindex = sum([matches.strength])/sum([matches.weight])*nmin/nmax;
