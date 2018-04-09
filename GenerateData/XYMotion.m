clear
clc
close all

%% store the data in corresponding path (NoMotion)
% make the directory for Left & Right Images
path_xymotion = '../Data/SimulateData/XYMotion';
tof = exist(path_xymotion, 'dir');
if tof ~= 7
    mkdir(path_xymotion);
end

path_xymotion_left = '../Data/SimulateData/XYMotion/Left/images/';
tof = exist(path_xymotion_left, 'dir');
if tof ~= 7
    mkdir(path_xymotion_left);
end

path_xymotion_right = '../Data/SimulateData/XYMotion/Right/images/';
tof = exist(path_xymotion_right, 'dir');
if tof ~= 7
    mkdir(path_xymotion_right);
end

%% load video and extract image
vidObj = VideoReader('../Data/stereo1.avi');  % camera_static
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

% Correct the distortion from Camera Lens
K = [530.90002, 0,         136.63037; 
      0,         581.00362, 161.32884; 
      0,         0,         1]; 
radialDistortion = [-0.3361 0.0921]; 
tangentialDistortion = [-0.00212 0.00152];

cameraParams = cameraParameters('IntrinsicMatrix', K, ...
    'RadialDistortion',radialDistortion, ...
    'TangentialDistortion',tangentialDistortion);

% Put into corresponding folder
path_xymotion_left = '../Data/SimulateData/XYMotion/Left/images/';
path_xymotion_right = '../Data/SimulateData/XYMotion/Right/images/';

crop = 6;
s1 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);
s2 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);

% Add Camera Motion
dis_yper = 0.2; 
dis_y = floor(vidHeight * dis_yper / 2);
y_m = floor([0:0.6:dis_y,...
             dis_y:-0.6:0,...
             0:-0.6:-dis_y, ...
             -dis_y:0.6:0, ...
             ]);  % assign the motion needed for each step

dis_xper = 0.2;
dis_x = floor((vidWidth/2-2*crop+1 ) * dis_xper / 2);
x_m = floor([0:0.6:dis_x,...
             dis_x:-0.6:0,...
             0:-0.6:-dis_x, ...
             -dis_x:0.6:0, ...
             ]);  % assign the motion needed for each step

% motion list for moving the view of field
x_motionlist = [x_m, zeros(size(y_m))];
y_motionlist = [zeros(size(x_m)), y_m];

% image size with the new view of field
h = vidHeight;
w = (vidWidth/2-2*crop+1);
h_new = floor((1 - dis_yper) * h);
w_new = floor((1 - dis_xper) * w);

k = 1;
while hasFrame(vidObj)
    I = readFrame(vidObj);
    s1(k).cdata = I(:, crop:end/2-crop, :);
    s2(k).cdata = I(:, end/2+crop:end-crop, :);
    
    img1 = s1(k).cdata;
    img2 = s2(k).cdata;
    img1_corr = undistortImage(img1,cameraParams);
    img2_corr = undistortImage(img2,cameraParams);
    
    cy = h/2 + y_motionlist(k); cx = w/2 + x_motionlist(k);
    ry = cy - h_new/2:cy + h_new/2; rx = cx - w_new/2:cx + w_new/2; 
    img1_move = img1_corr(ry, rx, :); img1_move = imresize(img1_move, [h w]);
    img2_move = img2_corr(ry, rx, :); img2_move = imresize(img2_move, [h w]);
    
    imwrite(img1_move, strcat(path_xymotion_left, sprintf('%05d_left.png', k)));
    imwrite(img2_move, strcat(path_xymotion_right, sprintf('%05d_right.png', k)));
    
    k = k+1;
end

fprintf(strcat('XYMotion data done, saved in ', path_nomotion));
