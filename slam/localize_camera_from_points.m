% This function takes 3-D points and their reprojection 2-D points in
% setero camera, then return the estimation position of stereo camera.
% Inputs:
%   P  - Nx3 matrix of 3D coordinates
%   p1 - Nx2 set of points in left camera
%   p2 - Nx2 set of points in right camera
%   K1 - 3x3 camera calibration matrix 1 of left camera
%   K2 - 3x3 camera calibration matrix 2 of right camera
%   M_diff - 3x4 Extrinsic matrix from left to right (Right M2- Left M1 = M)
%   M1_init -3x4 Inital extrinsic matrix value for left camera

% Outputs:
%   C1 - Nx2 matrix of (x, y) coordinates

function [M1, M2] = localize_camera_from_points(P,p1,p2,K1,K2,M_diff,M1_init)
R1_init = M1_init(:,1:3);
t1_init = M1_init(:,4);
r1_init = invRodrigues(R1_init);
x_init = [r1_init;t1_init];

fun = @(x)rodriguesResidual(P,p1,p2,K1,K2,M_diff,x);
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', ...
     'Display', 'Iter', 'MaxFunctionEvaluations', 120000);
x = lsqnonlin(fun, x_init, [], [], options);

r1 = x(1:3);
t1 = x(4:6);
R1 = rodrigues(r1);
M1_homo = [R1 t1; 0 0 0 1];
M2_homo = M1_homo*M_diff;
M1 = [R1 t1];
M2 = M2_homo(1:3,:);
end