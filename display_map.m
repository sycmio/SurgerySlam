load('P.mat');
load('OC1.mat');
clc;

f1 = figure;
img_path1 = 'Data\NoMotion\Left\images\00096_left.png';

I1 = imread(img_path1);
imshow(I1);
hold on;
plot(p_l(:,1), p_l(:,2), '.g', 'MarkerSize', 6);
hold off;

f2 = figure;
img_path2 = 'Data\NoMotion\Right\images\00096_right.png';
I2 = imread(img_path2);
imshow(I2);
hold on;
plot(p_r(:,1), p_r(:,2), '.g', 'MarkerSize', 6);

% draw 3d points
f3 = figure;
[N,~] = size(OC1);
x = P(:,1);
y = P(:,2);
z = P(:,3);

scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
% draw 3d camera positions
hold on;
for i = 1:N
    oc_x = OC1(i,1);
    oc_y = OC1(i,2);
    oc_z = OC1(i,3);
    h = scatter3(oc_x,oc_y,oc_z,'filled','MarkerFaceColor',[0 0 1]);
    drawnow
    pause(0.01);
    set(h,'Visible','off');
end

hold off;