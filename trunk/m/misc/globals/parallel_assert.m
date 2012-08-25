%> @ingroup globals parallelgroup
%> @file
%> @brief Makes sure that the PARALLEL global exists
function parallel_assert()
global PARALLEL;
if isempty(PARALLEL)
    parallel_reset();
end;
