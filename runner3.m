frame_num = 1;
img_path1 = num2str(frame_num, 'Data/XYMotion_test/Left/images/%05i_left.png');
img_path2 = num2str(frame_num, 'Data/XYMotion_test/Right/images/%05i_right.png');
I1 = rgb2gray(imread(img_path1));
I2 = rgb2gray(imread(img_path2));
[ p1, p2 ] = FindDensePair(I1, I2);