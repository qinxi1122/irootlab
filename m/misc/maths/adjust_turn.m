%> @ingroup maths
%> @file
%> @brief Turns columns vectors so that their largest element is positive
%>
%> This functio makes sense with eigenvectors of some matrix
%
%> @param L Loadings matrix
%> @return @em L Adjusted Loadings matrix
function L = adjust_turn(L)
% % % [vv, ii] = max(abs(L), [], 1);
% % % for i = 1:size(L, 2)
% % %     if L(ii(i), i) < 0
% % %         fprintf('***** Turn column %d\n', i);
% % %         L(:, i) = -L(:, i);
% % %     end;
% % % end;

ss = sum(L, 1);
for i = 1:size(L, 2)
    if ss(i) < 0
        fprintf('***** Turn column %d\n', i);
        L(:, i) = -L(:, i);
    end;
end;