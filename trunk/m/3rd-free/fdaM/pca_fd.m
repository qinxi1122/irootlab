function pcastr = pca_fd(fdobj, nharm, harmfdPar, centerfns)
%  PCA Functional principal components analysis with regularization
%
%  Arguments:
%  FDOBJ     ... Functional data object (a struct object)
%  NHARM     ... Number of principal components to be kept. Default 2
%  HARMFDPAR ... A functional parameter object specifying the
%                basis, differential operator, and level of smoothing
%                for eigenfunctions.
%  CENTERFNS ... If 1, the mean function is first subtracted from each function
%                1 is the default.
%
%  Returns:
%  A struct object PCASTR with the fields:
%  HARMFD  ... A functional data object for the harmonics or eigenfunctions
%  EIGVALS ... The complete set of eigenvalues
%  HARMSCR ... A matrix of scores on the principal components or harmonics
%  VARPROP ... A vector giving the proportion of variance explained
%                 by each eigenfunction
%  MEANFD  ... A functional data object giving the mean function
%
%  If NHARM = 0, all fields except MEANFD are empty.

%  Last modified:  30 October 2007

%  check FDOBJ

if ~isa_fd(fdobj)
    error ('First argument is not a functional data object.');
end

%  get basis information

fdbasis  = getbasis(fdobj);

%  set up default values

if nargin < 4
    centerfns = 1;
end
if nargin < 3
    Lfdobj    = int2Lfd(2);
    lambda    = 0;
    harmfdPar = fdPar(fdbasis, Lfdobj, lambda);
else
    %  check harmfdPar object
    if ~isa_fdPar(harmfdPar)
        if isa_fd(harmfdPar) || isa_basis(harmfdPar)
            harmfdPar = fdPar(harmfdPar);
        else
            error(['HARMFDPAR is not a functional parameter object, ', ...
                'not a functional data object, and ', ...
                'not a basis object.']);
        end
    end
end

if nargin < 2
    nharm = 2;
end

%  compute mean function and center if required

meanfd = mean(fdobj);

if nharm > 0

    if centerfns ~= 0
        fdobj = center(fdobj);
    end

    %  set up HARMBASIS
    %  currently, this is forced to be the same as FDBASIS

    harmbasis = fdbasis;

    %  set up LFDOBJ

    Lfdobj = getLfd(harmfdPar);
    Lfdobj = int2Lfd(Lfdobj);

    %  set up LAMBDA

    lambda = getlambda(harmfdPar);

    %  get coefficient matrix and its dimensions

    coef   = getcoef(fdobj);
    coefd  = size(coef);
    nbasis = coefd(1);
    nrep   = coefd(2);
    ndim   = length(coefd);
    if nrep < 2
        error('PCA not possible without replications');
    end


    %  compute CTEMP whose cross product is needed

    if ndim == 3
        nvar  = coefd(3);
        ctemp = zeros(nvar*nbasis,nrep);
        for j = 1:nvar
            index = (1:nbasis) + (j-1)*nbasis;
            ctemp(index,:) = coef(:,:,j);
        end
    else
        nvar = 1;
        ctemp = coef;
    end

    %  set up cross product and penalty matrices

    Cmat = ctemp*ctemp'./nrep;
    Jmat = eval_penalty(harmbasis, int2Lfd(0));
    if lambda > 0
        Kmat = eval_penalty(harmbasis, Lfdobj);
        Wmat = Jmat + lambda .* Kmat;
    else
        Wmat = Jmat;
    end
    Wmat = (Wmat + Wmat')/2;

    %  compute the Choleski factor of Wmat

    Lmat    = chol(Wmat);
    Lmatinv = inv(Lmat);

    %  set up matrix for eigenanalysis

    if nvar == 1
        if lambda > 0
            Cmat = Lmatinv' * Jmat * Cmat * Jmat * Lmatinv;
        else
            Cmat = Lmat * Cmat * Lmat';
        end
    else
        for i = 1:nvar
            indexi =   (1:nbasis) + (i-1)*nbasis;
            for j = 1:nvar
                indexj = (1:nbasis) + (j-1)*nbasis;
                if lambda > 0
                    Cmat(indexi,indexj) = ...
                        Lmatinv' * Jmat * Cmat(indexi,indexj) * Jmat * Lmatinv;
                else
                    Cmat(indexi,indexj) = Lmat * Cmat(indexi,indexj) * Lmat';
                end
            end
        end
    end

    % Eigenanalysis

    Cmat = (Cmat + Cmat')./2;
    [eigvecs, eigvals] = eig(Cmat);
    [eigvals, indsrt ] = sort(diag(eigvals));
    eigvecs = eigvecs(:,indsrt);
    neig    = nvar*nbasis;
    indx    = neig + 1 - (1:nharm);
    eigvals = eigvals(neig + 1 - (1:neig));
    eigvecs = eigvecs(:,indx);
    sumvecs = sum(eigvecs);
    eigvecs(:,sumvecs < 0) = -eigvecs(:,sumvecs < 0);

    varprop = eigvals(1:nharm)./sum(eigvals);

    if nvar == 1
        harmcoef  = Lmatinv * eigvecs;
        harmscr   = ctemp' * Lmat' * eigvecs;
        fdhatcoef = harmcoef*harmscr';
    else
        harmcoef  = zeros(nbasis,nharm,nvar);
        harmscr   = zeros(nrep,nharm);
        fdhatcoef = zeros(nbasis,nrep,nvar);
        for j = 1:nvar
            index     = (1:nbasis) + (j-1)*nbasis;
            ctempj    = ctemp(index,:);
            eigvecsj  = eigvecs(index,:);
            harmcoefj = Lmatinv*eigvecsj;
            harmscrj  = ctempj'*Lmat'*eigvecsj;
            harmscr   = harmscr + harmscrj;
            harmcoef(:,:,j)  = harmcoefj;
            fdhatcoef(:,:,j) = harmcoefj*harmscrj';
        end
    end

    %  Set up fdnames for harmfd
    
    harmnames = getnames(fdobj);
    %  Name and labels for harmonics
    harmlabels = ['I   '; 'II  '; 'III '; 'IV  '; 'V   '; ...
                  'VI  '; 'VII '; 'VIII'; 'IX  '; 'X   '];
    if nharm <= 10
        harmnames2    = cell(1,2);
        harmnames2{1} = 'Harmonics';
        harmnames2{2} = harmlabels(1:nharm,:);
        harmnames{2}  = harmnames2;
    else
        harmnames{2} = 'Harmonics';
    end
    %  Name and labels for variables
    if iscell(harmnames{3})
        harmnames3    = harmnames{3};
        harmnames3{1} = ['Harmonics for',harmnames3{1}];
        harmnames{3}  = harmnames3;
    else
        if ischar(harmnames{3}) && size(harmnames{3},1) == 1
            harmnames{3} = ['Harmonics for',harmnames{3}];
        else
            harmnames{3} = 'Harmonics';
        end
    end
            
    %  set up harmfd
    
    harmfd = fd(harmcoef, fdbasis, harmnames);
    
    %  set up structure object PCASTR

    pcastr.harmfd  = harmfd;
    pcastr.values  = eigvals;
    pcastr.harmscr = harmscr;
    pcastr.varprop = varprop;
    pcastr.fdhatfd = fd(fdhatcoef, fdbasis);

else

    pcastr.harmfd  = [];
    pcastr.values  = [];
    pcastr.harmscr = [];
    pcastr.varprop = [];
    pcastr.fdhatfd = [];
end

pcastr.meanfd  = meanfd;

