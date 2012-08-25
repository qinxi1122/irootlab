%>@ingroup misc reinforcement
%> @file
%> @brief Checks whether the columns of X have mean zero up to a certain tolerance.
%>
%> For instance, if tolerance is 0.02, a maximum abs(mean) = 0.02 will be accepted

%> @param X Input matrix
%> @param tolerance =0.02 Tolerance
%> @return Nothing. If fails, wil generate an error.
function assert_meancentered(X, tolerance)

mm = max(abs(mean(X)));

if mm > tolerance
    irerror(sprintf('A variable with abs(mean) = %g was found!', mm));
end;
