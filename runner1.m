% suppose points are static, get camera pos
addpath(genpath(pwd));

% load('MyMat/pairs_z.mat');

K1 = [530.90002, 0,         136.63037; 
      0,         581.00362, 161.32884; 
      0,         0,         1];
K2 = [524.84413, 0,         216.17358; 
      0,         577.11024, 149.76379; 
      0,         0,         1];
M_diff = [0.9990  0.0117   0.0425   -5.49238;
          -0.0112    0.9999  -0.0102    0.04267;
          -0.0426   0.0097    0.9990  -0.39886;
          0        0          0       1];

M1 = [eye(3) zeros(3,1)];
M1_homo = [eye(3) zeros(3,1); 0 0 0 1];
M2_homo = M1_homo*M_diff;
M2 = M2_homo(1:3,:);

% C1 = K1*M1;
% C2 = K2*M2;
C1 = (K1*M1)';
C2 = (K2*M2)';

% reconstruct by each frame (3D position in local frame)
all_frame_number = length(pairs);
Ps = cell(1,all_frame_number);
for i=1:all_frame_number
    p1 = pairs{i}(:,1:2);
    p2 = pairs{i}(:,3:4);
%     [ P, err ] = reconstruct_from_stereo(C1, p1, C2, p2);
    [ P, err ] = triangulate(p1,p2,C1,C2);
    Ps{i} = P;
end

all_frame_number = length(pairs);

M1s = cell(1,all_frame_number);
M2s = cell(1,all_frame_number);
M1s{1} = M1;
M2s{1} = M2;

% currently assume points are static
for i=2:all_frame_number
%     p1 = pairs{i}(:,1:2);
%     p2 = pairs{i}(:,3:4);
%     [M1, M2] = localize_camera_from_points(P,p1,p2,K1,K2,M_diff,M1);
    M = Kabsch(Ps{1},Ps{i});
    M1s{i} = M1s{1}*M;
    M2s{i} = M1s{i}*M_diff;
end

OC1_bad = zeros(all_frame_number,3);
OC1_normal_bad = zeros(all_frame_number,3);
for i=1:all_frame_number
    M1 = M1s{i};
    [OC,OC_normal] = compute_optical_center(M1);
    OC1_bad(i,:) = OC';
    OC1_normal_bad(i,:) = OC_normal';
end