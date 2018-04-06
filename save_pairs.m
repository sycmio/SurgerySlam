addpath(genpath(pwd));

base_path = 'Data/';
start_frame = 1;
end_frame = 1573;

%parameters according to the paper
params.padding = 1.0;         			   % extra area surrounding the target
params.output_sigma_factor = 1/16;		   % spatial bandwidth (proportional to target)
params.sigma = 0.2;         			   % gaussian kernel bandwidth
params.lambda = 1e-2;					   % regularization (denoted "lambda" in the paper)
params.learning_rate = 0.075;			   % learning rate for appearance model update scheme (denoted "gamma" in the paper)
params.compression_learning_rate = 0.15;   % learning rate for the adaptive dimensionality reduction (denoted "mu" in the paper)
params.non_compressed_features = {'gray'}; % features that are not compressed, a cell with strings (possible choices: 'gray', 'cn')
params.compressed_features = {'cn'};       % features that are compressed, a cell with strings (possible choices: 'gray', 'cn')
params.num_compressed_dim = 2;             % the dimensionality of the compressed features

params.visualization = 1;

%ask the user for the video
video_path = choose_video(base_path);
if isempty(video_path), return, end  %user cancelled

[img_files,video_path] = load_video_info(video_path,start_frame,end_frame);
pos = [220,300];
target_sz = [95, 95];
params.init_pos = floor(pos) + floor(target_sz/2);
params.wsize = floor(target_sz);
params.img_files = img_files;
params.video_path = video_path;

[positions, fps] = color_tracker(params);


clear
clc
close all

%% load video and extract image
vidObj = VideoReader(strcat(video_path,'video.avi'));  % camera_static
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

k = 1;
while hasFrame(vidObj)
    s(k).cdata = readFrame(vidObj);
    k = k+1;
end

img = s(5).cdata;
img_l = im2double(img(:, 1:end/2, :)); img_r = im2double(img(:, end/2:end, :));
figure,imshow(img_l, []); figure,imshow(img_r, []);

%% find corresponding points
[ p_l, p_r ] = Find2DPointPair(img_l, img_r);

figure, imshow(img_l); hold on
plot(p_l(:,2), p_l(:,1), '.g', 'MarkerSize', 6); hold off
figure, imshow(img_r); hold on
plot(p_r(:,2), p_r(:,1), '.g', 'MarkerSize', 6); hold off