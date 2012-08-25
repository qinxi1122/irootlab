%>@ingroup misc reinforcement
%>@file
%>@brief Checks whether the columns of X have mean zero and variance 1 up to a certain tolerance.
%>
%> For instance, if tolerance is 0.02, a maximum abs(mean) = 0.02 and variance = 1.02 will be accepted.
%
%> @param X Input matrix
%> @param tolerance =0.02 Tolerance
%> @return Nothing. If fails, wil generate an error.
function assert_standardized(X, tolerance)

vv = max(var(X)-1);

if vv > tolerance
    irerror('A variable with variance %g was found. Standardize (pre-processing) first!', vv+1);
end;

mm = max(abs(mean(X)));

if mm > tolerance
    irerror(sprintf('A variable with abs(mean) = %g was found. Standardize (pre-processing) first!', mm));
end;
