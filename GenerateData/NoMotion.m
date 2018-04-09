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
path_nomotion_left = '../Data/SimulateData/NoMotion/Left/images/';
path_nomotion_right = '../Data/SimulateData/NoMotion/Right/images/';

k = 1;
while hasFrame(vidObj)
    I = readFrame(vidObj);
    s1(k).cdata = I(:, crop:end/2-crop, :);
    s2(k).cdata = I(:, end/2+crop:end-crop, :);
    
    img1 = s1(k).cdata;
    img2 = s2(k).cdata; 
    img1_corr = undistortImage(img1,cameraParams);
    img2_corr = undistortImage(img2,cameraParams);
    
    imwrite(img1, strcat(path_nomotion_left, sprintf('%05d_left.png', k)));
    imwrite(img2, strcat(path_nomotion_right, sprintf('%05d_right.png', k)));
    
    k = k+1;
end

fprintf(strcat('NoMotion data done, saved in ', path_nomotion));
