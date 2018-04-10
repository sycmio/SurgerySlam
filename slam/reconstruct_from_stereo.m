% This function uses given stereo camera to reconstruct 3-D points from
% left and right pictures
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error
function [ P, err ] = reconstruct_from_stereo(C1, p1, C2, p2)
N = size(p1,1);
P = zeros(N,3);
% compute 3-D points
for i=1:N
    A = [p1(i,1)*C1(3,:)-C1(1,:);
       p1(i,2)*C1(3,:)-C1(2,:);
       p2(i,1)*C2(3,:)-C2(1,:);
       p2(i,2)*C2(3,:)-C2(2,:)];
    [V,D] = eig(A);
    [~,I] = sort(abs(diag(D)));
    X = V(1:3, I(1))/V(4, I(1));
    P(i,:) = X';
end
% compute the points projection
project_1_homo = (C1*([P ones(N,1)]'))';
project_1 = project_1_homo(:,1:2)./project_1_homo(:,3);
project_2_homo = (C2*([P ones(N,1)]'))';
project_2 = project_2_homo(:,1:2)./project_2_homo(:,3);

err = norm(reshape([p1-project_1; p2-project_2], [], 1))^2;
P = real(P);
end