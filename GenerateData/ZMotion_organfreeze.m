clear
clc
close all

%% store the data in corresponding path (ZMotion)
% make the directory for Left & Right Images
path_zmotion = '../Data/SimulateData/ZMotion_organfreeze';
tof = exist(path_zmotion, 'dir');
if tof ~= 7
    mkdir(path_zmotion);
end

path_zmotion_left = '../Data/SimulateData/ZMotion_organfreeze/Left/images/';
tof = exist(path_zmotion_left, 'dir');
if tof ~= 7
    mkdir(path_zmotion_left);
end

path_zmotion_right = '../Data/SimulateData/ZMotion_organfreeze/Right/images/';
tof = exist(path_zmotion_right, 'dir');
if tof ~= 7
    mkdir(path_zmotion_right);
end

%% load video and extract image
vidObj = VideoReader('../Data/stereo1.avi');  % camera_static
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

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
path_xyzmotion_left = '../Data/SimulateData/ZMotion_organfreeze/Left/images/';
path_xyzmotion_right = '../Data/SimulateData/ZMotion_organfreeze/Right/images/';

crop = 6;
s1 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);
s2 = struct('cdata',zeros(vidHeight,vidWidth/2-2*crop+1,3,'uint8'),'colormap',[]);


% Add Z Motion
zoom_scale = 0.1;
list_cos = linspace(0, 2*pi*12, 100);
zoom_factor = ((-cos(list_cos) + 1))/2 * zoom_scale + 1; % assign the motion needed for each step

% Shift the view of field (Right Camera)
x_shiftlist = -floor((zoom_factor - 1).*200);
y_shiftlist = zeros(size(zoom_factor));

% image size with the new view of field
dis_yper = 0.15;
dis_xper = 0.15;
h = vidHeight;
w = (vidWidth/2-2*crop+1);
h_new = floor((1 - dis_yper) * h);
w_new = floor((1 - dis_xper) * w);

k = 1;
while hasFrame(vidObj)
    I = readFrame(vidObj);
    s1(k).cdata = I(:, crop:end/2-crop, :);
    s2(k).cdata = I(:, end/2+crop:end-crop, :);
    
    img1 = s1(1).cdata;  % only choose the first image
    img2 = s2(1).cdata;  % only choose the first image
    img1_corr = undistortImage(img1,cameraParams1);
    img2_corr = undistortImage(img2,cameraParams1);
    
    % get the zoom in images
    img1_zoom = imresize(img1_corr, zoom_factor(k)); 
    img2_zoom = imresize(img2_corr, zoom_factor(k));
    c_r= floor(size(img1_zoom,1)/2); c_c = floor(size(img1_zoom,2)/2);
    img1_zoom = img1_zoom(c_r-h/2+1:c_r+h/2, c_c-w/2+1:c_c+w/2, :);
    img2_zoom = img2_zoom(c_r-h/2+1:c_r+h/2, c_c-w/2+1:c_c+w/2, :);
    
    % get the cropped images
    cy = floor(h/2) + y_shiftlist(k); 
    cx = floor(w/2) + x_shiftlist(k);
    ry = cy - floor(h_new/2):cy + floor(h_new/2); 
    rx = cx - floor(w_new/2):cx + floor(w_new/2); 
    img1_move = img1_zoom(ry, rx, :); img1_move = imresize(img1_move, [h w]);
    img2_move = img2_zoom(ry, rx, :); img2_move = imresize(img2_move, [h w]);
    
    imwrite(img1_move, strcat(path_xyzmotion_left, sprintf('%05d_left.png', k)));
    imwrite(img2_move, strcat(path_xyzmotion_right, sprintf('%05d_right.png', k)));
    
    k = k+1;
end

fprintf(strcat('ZMotion_organfreeze data done, saved in ', path_nomotion));
