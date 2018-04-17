function [OC,OC_normal] = compute_optical_center(M)
% Take 4x4 extrinsic matrix M as input
% OC is 3x1 optical center position

% [V,D] = eig(P'*P);
% [~,I] = sort(abs(diag(D)));
% OC = V(1:3, I(1))/V(4, I(1));

R = M(1:3,1:3);
T = M(1:3,4);
OC = -R'*T;
OC_normal = R'*[0;0;1];

end