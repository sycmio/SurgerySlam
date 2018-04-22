% integrate point motion model, get camera pos

addpath(genpath(pwd));
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

C1 = (K1*M1)';
C2 = (K2*M2)';

% reconstruct to find motion model, suppose camera are static
cali_frame_number = 100;
all_frame_number = length(pairs);

Ps = cell(1,cali_frame_number);
for i=1:cali_frame_number
    p1 = pairs{i}(:,1:2);
    p2 = pairs{i}(:,3:4);
%     [ P, err ] = reconstruct_from_stereo(C1, p1, C2, p2);
    [ P, err ] = triangulate(p1,p2,C1,C2);
    Ps{i} = P;
end
t_start = 1; t_end = all_frame_number;

minPeakDis=0; minPeakHei=0;
[Ps_mat_t, Period] = LocalizePointPCA(Ps, t_start, t_end, minPeakDis, minPeakHei);

% reconstruct points in each camera frame, find the camera position

Ps = cell(1,all_frame_number);
for i=1:all_frame_number
    p1 = pairs{i}(:,1:2);
    p2 = pairs{i}(:,3:4);
%     C1 = C1';
%     C2 = C2';
%     [ P, err ] = reconstruct_from_stereo(C1, p1, C2, p2);
    [ P, err ] = triangulate(p1,p2,C1,C2);
    Ps{i} = P;
end

M1s = cell(1,all_frame_number);
M2s = cell(1,all_frame_number);
M1s{1} = [M1;0 0 0 1];
M2s{1} = [M2;0 0 0 1];

% for i=1:100
%     Ps{i} = Ps_mat_t{i};
% end
% 
% for i=101:200
%     Ps{i} = Ps_mat_t{i}+(i-100)*repmat([0.03 0 0],[20,1]);
% end
% 
% for i=201:all_frame_number
%     Ps{i} = Ps_mat_t{i}+100*repmat([0.03 0 0],[20,1])-(i-200)*repmat([0.03 0 0],[20,1]);
% end

for i=2:all_frame_number
%     p1 = pairs{i}(:,1:2);
%     p2 = pairs{i}(:,3:4);
%     [M1, M2] = localize_camera_from_points(P,p1,p2,K1,K2,M_diff,M1);

%     tmp_R = M1s{i-1}(1:3,1:3);
%     tmp_T = M1s{i-1}(1:3,4);
%     tmp_P = Ps_mat_t{i}';
%     tmp_P = tmp_R*tmp_P+tmp_T;
%     tmp_P = tmp_P';
%     M = Kabsch(tmp_P,Ps{i});
%     M1s{i} = M1s{i-1}*M;
    M = Kabsch(Ps_mat_t{i},Ps{i});
    M1s{i} = M1s{1}*M;
    M2s{i} = M1s{i}*M_diff;
    
%     p1 = pairs{i}(:,1:2);
%     p2 = pairs{i}(:,3:4);
%     [M1, M2, P] = localize_camera_from_points(Ps_mat_t{i},p1,p2,K1,K2,M_diff,M1s{i});
%     M1s{i} = M1;
%     M2s{i} = M2;
end

OC1 = zeros(all_frame_number,3);
OC1_normal = zeros(all_frame_number,3);
for i=1:all_frame_number
    M1 = M1s{i};
    [OC,OC_normal] = compute_optical_center(M1);
    OC1(i,:) = OC';
    OC1_normal(i,:) = OC_normal';
end