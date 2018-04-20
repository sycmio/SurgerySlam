function residuals = rodriguesResidual(P,p1,p2,K1,K2,M_diff,x)
% rodriguesResidual:
% Inputs:
%   P  - Nx3 matrix of 3D coordinates
%   p1 - Nx2 set of points in left camera
%   p2 - Nx2 set of points in right camera
%   K1 - 3x3 camera calibration matrix 1 of left camera
%   K2 - 3x3 camera calibration matrix 2 of right camera
%   M_diff - 4x4 Extrinsic matrix from left to right (Right M2_homo = Left M1_homo * M_diff)
%   x - 6x1 flattened concatenation of r_1 and t_1

% Output:
%   residuals - 4Nx1 vector
r1 = x(1:3);
t1 = x(4:6);
R1 = rodrigues(r1);
M1_homo = [R1 t1; 0 0 0 1];
M2_homo = M1_homo*M_diff;
M1 = [R1 t1];
M2 = M2_homo(1:3,:);
N = size(P,1);
C1 = K1*M1;
C2 = K2*M2;

project_1_homo = (C1*([P ones(N,1)]'))';
project_1 = project_1_homo(:,1:2)./project_1_homo(:,3);
project_2_homo = (C2*([P ones(N,1)]'))';
project_2 = project_2_homo(:,1:2)./project_2_homo(:,3);
residuals = reshape([p1-project_1; p2-project_2], [], 1);
end