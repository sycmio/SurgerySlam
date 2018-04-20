% suppose points are static, plot camera trajatory

% load('MyMat\pairs.mat');

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