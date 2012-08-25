%> @file
%> @ingroup misc

%> @brief Runs a single train-test and returns the logged logs
function [logs, blk] = singlett(logs, blk, ds_train, ds_test, postpr_test, postpr_est)

if nargin < 6 || isempty(postpr_est)
    postpr_est = decider();
end;

if nargin < 5
    postpr_test = [];
end;

blk = blk.boot();
blk = blk.train(ds_train);
[blk, est] = blk.use(ds_test);

if ~isempty(postpr_est)
    est = postpr_est.use(est);
end;


if ~isempty(postpr_test)
    dref = postpr_test.use(ds_test);
else
    dref = ds_test;
end;

pars = struct('est', {est}, 'dref', {dref}, 'clssr', {blk});
for il = 1:numel(logs)
    logs{il} = logs{il}.record(pars);
end;
