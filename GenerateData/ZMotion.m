clear
clc
close all

%% store the data in corresponding path (ZMotion)
% make the directory for Left & Right Images
path_zmotion = '../Data/SimulateData/ZMotion';
tof = exist(path_zmotion, 'dir');
if tof ~= 7
    mkdir(path_zmotion);
end

path_zmotion_left = '../Data/SimulateData/ZMotion/Left/images/';
tof = exist(path_zmotion_left, 'dir');
if tof ~= 7
    mkdir(path_zmotion_left);
end

path_zmotion_right = '../Data/SimulateData/ZMotion/Right/images/';
tof = exist(path_zmotion_right, 'dir');
if tof ~= 7
    mkdir(path_zmotion_right);
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
path_zmotion_left = '../Data/SimulateData/ZMotion/Left/images/';
path_zmotion_right = '../Data/SimulateData/ZMotion/Right/images/';

crop = 6;
s1 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);
s2 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);

% Add Z Motion
zoom_factor = [1:0.005:1.6, 1.6:-0.005:1];% assign the motion needed for each step

% image size with the new view of field
h = vidHeight;
w = (vidWidth/2-2*crop+1);

k = 1;
while hasFrame(vidObj)
    I = readFrame(vidObj);
    s1(k).cdata = I(:, crop:end/2-crop, :);
    s2(k).cdata = I(:, end/2+crop:end-crop, :);
    
    img1 = s1(1).cdata;  % only choose the first image
    img2 = s2(1).cdata;  % only choose the first image
    img1_corr = undistortImage(img1,cameraParams);
    img2_corr = undistortImage(img2,cameraParams);
    
    img1_zoom = imresize(img1_corr, zoom_factor(k)); 
    img2_zoom = imresize(img2_corr, zoom_factor(k));
    c_r= floor(size(img1_zoom,1)/2); c_c = floor(size(img1_zoom,2)/2);
    img1_zoom = img1_zoom(c_r-h/2+1:c_r+h/2, c_c-w/2+1:c_c+w/2, :);
    img2_zoom = img2_zoom(c_r-h/2+1:c_r+h/2, c_c-w/2+1:c_c+w/2, :);
    
    imwrite(img1_zoom, strcat(path_zmotion_left, sprintf('%05d_left.png', k)));
    imwrite(img2_zoom, strcat(path_zmotion_right, sprintf('%05d_right.png', k)));
    
    k = k+1;
end

fprintf(strcat('ZMotion data done, saved in ', path_nomotion));
