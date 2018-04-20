%  Load point correspondences
%  Obtain the correct M2

function M2 = findM2(im1,im2,pts1,pts2,K1,K2)

M = max(length(im1),length(im2));
F = compute_fundamental_matrix(pts1, pts2, M);

E = compute_essential_matrix(F, K1, K2);
M2s = camera2(E);
min_error = Inf;
C1 = K1*[eye(3) zeros(3,1)];
p1 = pts1;
p2 = pts2;
% choose the best M2
for i=1:size(M2s,3)
    C2_possible = K2*M2s(:,:,i);
    [P_possible, err] = reconstruct_from_stereo(C1, p1, C2_possible, p2);
    if all(P_possible(:,3)>0) && err<min_error
        P = P_possible;
        min_error = err;
        M2 = M2s(:,:,i);
        C2 = K2*M2;
    end
end

end