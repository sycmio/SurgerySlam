function [ E ] = compute_essential_matrix( F, K1, K2 )
% essentialMatrix:
%    F - 3x3 Fundamental Matrix
%    K1 - 3x3 Camera Matrix 1
%    K2 - 3x3 Camera Matrix 2

E = K2'*F*K1;
end