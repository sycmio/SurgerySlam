clear
clc
close all

%% store the data in corresponding path (NoMotion)
% make the directory for Left & Right Images
path_nomotion = '../Data/SimulateData/NoMotion';
tof = exist(path_nomotion, 'dir');
if tof ~= 7
    mkdir(path_nomotion);
end

path_nomotion_left = '../Data/SimulateData/NoMotion/Left/images/';
tof = exist(path_nomotion_left, 'dir');
if tof ~= 7
    mkdir(path_nomotion_left);
end

path_nomotion_right = '../Data/SimulateData/NoMotion/Right/images/';
tof = exist(path_nomotion_right, 'dir');
if tof ~= 7
    mkdir(path_nomotion_right);
end

%% load video and extract image
vidObj = VideoReader('../Data/stereo1.avi');  % camera_static
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

crop = 6;
s1 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);
s2 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);

% Correct the distortion from Cameras Lens
K1 = [530.90002, 0,         136.63037; 
      0,         581.00362, 161.32884; 
      0,         0,         1]; 
radialDistortion1 = [-0.28650 0.29524]; 
tangentialDistortion1 = [-0.00212 0.00152];
cameraParams1 = cameraParameters('IntrinsicMatrix', K1, ...
    'RadialDistortion',radialDistortion1, ...
    'TangentialDistortion',tangentialDistortion1);

K2 = [524.84413, 0,         216.17358;   
      0,         577.11024, 149.76379;
      0,         0,         1]; 
radialDistortion2 = [-0.25745 0.62307]; 
tangentialDistortion2 = [0.03660 -0.01082];
cameraParams2 = cameraParameters('IntrinsicMatrix', K2, ...
    'RadialDistortion',radialDistortion2, ...
    'TangentialDistortion',tangentialDistortion2);

% Put into corresponding folder
path_nomotion_left = '../Data/SimulateData/NoMotion/Left/images/';
path_nomotion_right = '../Data/SimulateData/NoMotion/Right/images/';

k = 1;
while hasFrame(vidObj)
    I = readFrame(vidObj);
    s1(k).cdata = I(:, crop:end/2-crop, :);
    s2(k).cdata = I(:, end/2+crop:end-crop, :);
    
    img1 = s1(k).cdata;
    img2 = s2(k).cdata; 
    img1_corr = undistortImage(img1,cameraParams1);
    img2_corr = undistortImage(img2,cameraParams1);
    
    imwrite(img1, strcat(path_nomotion_left, sprintf('%05d_left.png', k)));
    imwrite(img2, strcat(path_nomotion_right, sprintf('%05d_right.png', k)));
    
    k = k+1;
end

fprintf(strcat('NoMotion data done, saved in ', path_nomotion));
