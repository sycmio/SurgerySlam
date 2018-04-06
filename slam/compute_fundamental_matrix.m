function [ F ] = compute_fundamental_matrix( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

%     Implement the eightpoint algorithm
%     Generate a matrix F from point pair

% scale the points
pts1 = pts1/M;
pts2 = pts2/M;
% decompose A to get F'
A = [pts2(:,1).*pts1(:,1), pts2(:,1).*pts1(:,2), pts2(:,1), pts2(:,2).*pts1(:,1), pts2(:,2).*pts1(:,2), pts2(:,2), pts1(:,1), pts1(:,2), ones(length(pts1),1)];
[U,D,V] = svd(A);
[~,I] = sort(diag(D));
F_prime = reshape(V(:, I(1)),[3,3])';
%decompose F' to get F
[Uf,Df,Vf] = svd(F_prime);
D_temp = sort(diag(Df));
Df = diag([D_temp(end:-1:2);0]);
F = Uf*Df*Vf';

T = [1/M,0,0;0,1/M,0;0,0,1];
% F = refineF(F,pts1,pts2);
F = T'*F*T;
end

