%> @brief Records row class versus assigned class
classdef estlog_classxclass < estlog
    properties
        %> All possible class labels in reference datasets
        testlabels = {};
        %> All possible class labels in estimation datasets
        estlabels = {};
        %> =0. What to give as a "rate". 0-mean sensitivity; 1-diagonal element defined by idx_rate
        ratemode = 0;
        %> =1. Diagonal element if @c ratemode is 1.
        idx_rate;
    end;
    
    methods
        function o = estlog_classxclass()
            o.classtitle = 'Class X Class';
            o.flag_sensspec = 1;
            o.flag_params = 1;
        end;
    end;
    
    methods(Access=protected)
        %> Returns the contents of the @c estlabels property.
        function z = get_collabels(o)
            z = o.estlabels;
        end;
        
        %> Returns the contents of the @c testlabels property.
        function z = get_rowlabels(o)
            z = o.testlabels;
        end;

        function o = do_record(o, pars)
            est = pars.est;
            ds_test = pars.ds_test;
            if numel(est.classes) ~= numel(ds_test.classes)
                irerror('Number of items in estimation is different from number of items in reference dataset!');
            end;
            estclasses = renumber_classes(est.classes, est.classlabels, o.estlabels);
            for i = 1:numel(o.testlabels)
                classidx = find(strcmp(o.testlabels{i}, ds_test.classlabels)); % rowlabel of turn class index in reference dataset
                if isempty(classidx)
                    % Class was not tested <--> not present in reference (test) dataset
                else
                    rowidxs = ds_test.classes == classidx-1; % Indexes of rows belonging to i-th class
                    sel = estclasses(rowidxs);
                    if o.flag_support
                        supp = est.X(rowidxs, 1)';
                    end;
                    
   
%                     % Method 1: better with more classes; better with less rows
%                     x = sort(sel);
%                     difference = diff([x;max(x)+1]); 
%                     count = diff(find([1;difference]));
%                     y = x(find(difference)); 
                    
                    % Method 2: better with fewer classes; better with more rows
                    % Both methods are quite quick anyway
                    for j = 1:numel(o.estlabels)
                        idxidxbool = sel == j-1;
                        o.hits(i, j+1, o.t) = o.hits(i, j+1, o.t)+sum(idxidxbool);
                        if o.flag_support
                            o.supports{i, j+1, o.t} = supp(idxidxbool); % Assumeed that est is the output of a decider block which produces a X with one feature only, which is the support.
                        end;
                    end;
                    
                    idxidxbool = sel == -1;
                    o.hits(i, 1, o.t) = sum(idxidxbool); % Rejection count.
                    if o.flag_support
                        o.supports{i, 1, o.t} = supp(idxidxbool); % Assumeed that est is the output of a decider block which produces a X with one feature only, which is the support.
                    end;
                end;
            end;
        end;
    end;

    methods
        
        
        %> Returns average sensitivity. Calculated as normalized sum.
        function z = get_meansens(o)
            C = o.get_C([], 0, 2);  % Gets row-wise-normalized sum
            div = (100-C(:, 1))+realmin; % Note that if element in first column is 100, others will be 0.
            senss = 100*diag(C(:, 2:end))./div; % Discounts rejected items
            z = mean(senss);
        end;
        
        %> Bypass to get_meansens()
        function z = get_rate(o)
            if o.ratemode == 0
                z = o.get_meansens();
            else
                C = o.get_C([], 0, 2);  % Gets normalized sum
                div = (100-C(o.idx_rate, 1))+realmin; % Note that if element in first column is 100, others will be 0.
                z = 100*C(o.idx_rate, o.idx_rate+1)/div;
            end;
        end;
        
        %> Returns average sensitivity vector calculated time-wise.
        function z = get_rates(o)
            CC = o.get_C([], 1, 0); % gets 3D time-wise normalized 
            W = o.get_weights([], 1); % (no_rows)x(no_t) matrix of weights
            n = size(CC, 3);
            z = zeros(1, n);
            for i = 1:n
                C = CC(:, :, i);  % Gets normalized sum
                
                if o.ratemode == 0
                    div = (100-C(:, 1))+realmin; % Note that if element in first column is 100, others will be 0.
                    senss = 100*diag(C(:, 2:end))./div; % Discounts rejected items
                    z(i) = senss'*W(:, i); % dot product
                else
                    div = (100-C(o.idx_rate, 1))+realmin; % Note that if element in first column is 100, others will be 0.
                    z(i) = 100*C(o.idx_rate, o.idx_rate+1)/div;
                end;
            end;
        end;
    end;    
end
