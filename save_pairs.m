addpath(genpath(pwd));

base_path = 'Data/';
start_frame = 1;
end_frame = 416;

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

video_path_left = [video_path 'Left/'];
video_path_right = [video_path 'Right/'];

[img_files_left,video_path_left] = load_video_info(video_path_left,start_frame,end_frame);
[img_files_right,video_path_right] = load_video_info(video_path_right,start_frame,end_frame);

img_l = imread([video_path_left img_files_left{1}]);
img_r = imread([video_path_right img_files_right{1}]);

% find pair in first frame
[ p_l, p_r ] = Find2DPointPair(img_l, img_r);
% [ p_l, p_r ] = FindDensePair(rgb2gray(im2double(img_l)), rgb2gray(im2double(img_r)));
% N = size(p_l,1);
% rand_index = randperm(N);
% rand_index = rand_index(1:20);
% p_l = p_l(rand_index,:);
% p_r = p_r(rand_index,:);

% calculate M2
% M2 = findM2(img_l,img_r,p_l,p_r,K,K);

% track pairs over video and store their positions
[pair_num,~] = size(p_l);
pairs = cell(1,end_frame-start_frame+1);
for i=1:end_frame-start_frame+1
    pairs{i} = zeros(0,4);
end

target_sz = [80, 80];
for i=1:pair_num
    pos = p_l(i,end:-1:1);
    params.init_pos = floor(pos);
    params.wsize = floor(target_sz);
    params.img_files = img_files_left;
    params.video_path = video_path_left;
    [positions, ~] = color_tracker(params);
    
    for j=1:end_frame-start_frame+1
        pairs{j} = [pairs{j};positions(j,end-2:-1:1) 0 0];
    end
    
    pos = p_r(i,end:-1:1);
    params.init_pos = floor(pos);
    params.wsize = floor(target_sz);
    params.img_files = img_files_right;
    params.video_path = video_path_right;
    [positions, ~] = color_tracker(params);
    
    for j=1:end_frame-start_frame+1
        pairs{j}(end,3:4) = positions(j,end-2:-1:1);
    end
    disp(i);
    close all
end