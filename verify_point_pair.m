% plot 2d point pairs on image to see whether it is correct pair
close all;
N=256;
images = cell(1,N);
f1 = figure;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

for i=1:N
    frame_num=i;
    subplot(1,2,1);
    hold on;
    img_path1 = num2str(frame_num, 'Data/XYMotion/Left/images/%05i_left.png');

    I1 = imread(img_path1);
    h1 = imshow(I1);    
%     h2 = rectangle('Position',[0.59,0.35,3.75,1.37]);
    h2 = plot(pairs{frame_num}(:,1), pairs{frame_num}(:,2), 'gs', 'MarkerSize', 10);
    hold off;
    
    subplot(1,2,2);
    hold on;
    img_path2 = num2str(frame_num, 'Data/XYMotion/Right/images/%05i_right.png');

    I2 = imread(img_path2);
    h3 = imshow(I2);
    h4 = plot(pairs{frame_num}(:,3), pairs{frame_num}(:,4), 'gs', 'MarkerSize', 10);
    hold off;
    
    F = getframe(gcf);
    images{i} = F.cdata;
    set(h1,'Visible','off');
    set(h2,'Visible','off');
    set(h3,'Visible','off');
    set(h4,'Visible','off');
end

writerObj = VideoWriter('result3.avi');
writerObj.FrameRate = 10;
open(writerObj);
 for u=1:length(images)
     % convert the image to a frame
     frame = im2frame(images{u}); 
     writeVideo(writerObj, frame);
 end
 close(writerObj);

%-------------------------------------------------
% frame_num = 60;
% f1 = figure;
% subplot(1,2,1);
% img_path1 = num2str(frame_num, 'Data/XYMotion/Left/images/%05i_left.png');
% I1 = imread(img_path1);
% imshow(I1);
% hold on;
% plot(pairs{frame_num}(:,1), pairs{frame_num}(:,2), 'gs', 'MarkerSize', 10);
% hold off;
% 
% img_path2 = num2str(frame_num, 'Data/XYMotion/Right/images/%05i_right.png');
% I2 = imread(img_path2);
% subplot(1,2,2);
% imshow(I2);
% hold on;
% plot(pairs{frame_num}(:,3), pairs{frame_num}(:,4), 'gs', 'MarkerSize', 10);
% hold off;