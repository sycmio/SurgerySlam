% suppose camera is static, get points trajatory

load('MyMat/pairs.mat');

K = [530.90002, 0,         136.63037; 
      0,         581.00362, 161.32884; 
      0,         0,         1]; 

M1 = [eye(3) zeros(3,1)];
M1_homo = [eye(3) zeros(3,1); 0 0 0 1];
M2_homo = M1_homo*M_diff;
M2 = M2_homo(1:3,:);

C1 = K*M1;
C2 = K*M2;

% reconstruct by each frame
all_frame_number = length(pairs);
Ps = cell(1,all_frame_number);
for i=1:all_frame_number
    p1 = pairs{i}(:,1:2);
    p2 = pairs{i}(:,3:4);
    [ P, err ] = reconstruct_from_stereo(C1, p1, C2, p2);
    Ps{i} = P;
end