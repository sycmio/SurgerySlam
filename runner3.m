% dense reconstruction by first frame

% addpath(genpath(pwd));
% frame_num = 1;
% img_path1 = num2str(frame_num, 'Data/XYMotion_test/Left/images/%05i_left.png');
% img_path2 = num2str(frame_num, 'Data/XYMotion_test/Right/images/%05i_right.png');
% I1 = rgb2gray(im2double(imread(img_path1)));
% I2 = rgb2gray(im2double(imread(img_path2)));
% [ p1, p2 ] = FindDensePair(I1, I2);
% 
% K1 = [530.90002, 0,         136.63037; 
%       0,         581.00362, 161.32884; 
%       0,         0,         1];
% K2 = [524.84413, 0,         216.17358; 
%       0,         577.11024, 149.76379; 
%       0,         0,         1];
% M_diff = [0.9990  0.0117   0.0425   -5.49238;
%           -0.0112    0.9999  -0.0102    0.04267;
%           -0.0426   0.0097    0.9990  -0.39886;
%           0        0          0       1];
% 
% M1 = [eye(3) zeros(3,1)];
% M1_homo = [eye(3) zeros(3,1); 0 0 0 1];
% M2_homo = M1_homo*M_diff;
% M2 = M2_homo(1:3,:);
% 
% % C1 = K1*M1;
% % C2 = K2*M2;
% C1 = (K1*M1)';
% C2 = (K2*M2)';
% 
% [ P, err ] = triangulate(p1,p2,C1,C2);

% ptCloud = pointCloud(single(P));

points3D = nan([size(I1), 3]);
for i = 1:size(p1, 1)
    points3D(p1(i,1), p1(i,2), :) = P(i,:);
end
points3D = single(points3D);

I3 = imread(img_path1);

% Convert to meters and create a pointCloud object
ptCloud = pointCloud(points3D, 'Color', I3);

% Create a streaming point cloud viewer
player3D = pcplayer([min(P(:,1)), max(P(:,1))], [min(P(:,2)), max(P(:,2))], [min(P(:,3)), max(P(:,3))], 'VerticalAxis', 'y', ...
    'VerticalAxisDir', 'down','MarkerSize',100);

% Visualize the point cloud
view(player3D, ptCloud);

% x = P(:,1);
% y = P(:,2);
% z = P(:,3);
% 
% h = scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
% drawnow