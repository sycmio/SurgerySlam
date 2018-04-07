load('pairs.mat');

K = [530.90002, 0,         136.63037; 
      0,         581.00362, 161.32884; 
      0,         0,         1]; 

M1 = [eye(3) zeros(3,1)];
M1_homo = [eye(3) zeros(3,1); 0 0 0 1];
M2_homo = M1_homo*M_diff;
M2 = M2_homo(1:3,:);

C1 = K*M1;
C2 = K*M2;

% reconstruct by first frame
p1 = p1s{1};
p2 = p2s{1};
[ P, err ] = reconstruct_from_stereo(C1, p1, C2, p2);

all_frame_number = length(p1);

M1s = cell(1,all_frame_number);
M2s = cell(1,all_frame_number);
M1s{1} = M1;
M2s{1} = M2;
% TODO: Is m_diff correct??

% currently assume points are static
for i=2:length(all_frame_number)
    p1 = p1s{i};
    p2 = p2s{i};
    [M1, M2] = localize_camera_from_points(P,p1,p2,K,K,M_diff,M1);
    M1s{i} = M1;
    M2s{i} = M2;
end