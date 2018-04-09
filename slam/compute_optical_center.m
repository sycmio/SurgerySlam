function [OC] = compute_optical_center(P)
% Take 3x4 projection matrix P as input
% OC is 3x1 optical center position

[V,D] = eig(P'*P);
[~,I] = sort(abs(diag(D)));
OC = V(1:3, I(1))/V(4, I(1));

end