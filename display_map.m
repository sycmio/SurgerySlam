% load('MyMat\P.mat');
% load('MyMat\OC1.mat');
% load('MyMat\pairs.mat');

% frame_num=1;
% 
% f1 = figure;
% img_path1 = num2str(frame_num, 'Data/ZMotion/Left/images/%05i_left.png');
% 
% I1 = imread(img_path1);
% imshow(I1);
% hold on;
% for i=1:20
%     plot(p_l(i,1), p_l(i,2), '.g', 'MarkerSize', 10);
% end
% hold off;
% 
% f2 = figure;
% img_path2 = num2str(frame_num, 'Data/ZMotion/Right/images/%05i_right.png');
% I2 = imread(img_path2);
% imshow(I2);
% hold on;
% plot(p_r(:,1), p_r(:,2), '.g', 'MarkerSize', 10);
% hold off;

% N = length(Ps);
% 
% % draw 3d points over time
% for i = 1:N
%     x = Ps{i}(:,1);
%     y = Ps{i}(:,2);
%     z = Ps{i}(:,3);
%     h = scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
%     axis([-20 20 -20 20 12 40]);
% %     axis([-10 10 -10 10 8 18]);
%     drawnow
%     pause(0.1);
%     set(h,'Visible','off');
% end
% hold off;

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
    axis([-10 10 -10 10 -1 30]);
    drawnow
    pause(0.1);
    set(h,'Visible','off');
end

hold off;