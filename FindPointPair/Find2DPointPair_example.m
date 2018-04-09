clear
clc
close all

%% load video and extract image
vidObj = VideoReader('../Data/stereo1.avi');  % camera_static
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
plot(p_l(:,1), p_l(:,2), '.g', 'MarkerSize', 6); hold off
figure, imshow(img_r); hold on
plot(p_r(:,1), p_r(:,2), '.g', 'MarkerSize', 6); hold off

