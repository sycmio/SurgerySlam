% plot 2d point pairs on image to see whether it is correct pair

frame_num=1;

f1 = figure;
img_path1 = num2str(frame_num, 'Data/ZMotion/Left/images/%05i_left.png');

I1 = imread(img_path1);
imshow(I1);
hold on;
plot(pairs{frame_num}(:,1), pairs{frame_num}(:,2), '.g', 'MarkerSize', 10);
hold off;

f2 = figure;
img_path2 = num2str(frame_num, 'Data/ZMotion/Right/images/%05i_right.png');
I2 = imread(img_path2);
imshow(I2);
hold on;
plot(pairs{frame_num}(:,3), pairs{frame_num}(:,4), '.g', 'MarkerSize', 10);
hold off;