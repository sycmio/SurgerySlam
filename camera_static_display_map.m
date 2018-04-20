% suppose camera are static, plot 3D points trajatory over time
N = length(Ps);

% draw 3d points over time
for i = 1:N
    x = Ps{i}(:,1);
    y = Ps{i}(:,2);
    z = Ps{i}(:,3);
    h = scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
    axis([-20 20 -20 20 12 40]);
%     axis([-10 10 -10 10 8 18]);
    drawnow
    pause(0.1);
    set(h,'Visible','off');
end
hold off;