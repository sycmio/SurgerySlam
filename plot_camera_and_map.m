N = length(Ps_mat_t);

hold on;
% draw 3d points and camera position over time
for i = 1:N
    x = Ps_mat_t{i}(:,1);
    y = Ps_mat_t{i}(:,2);
    z = Ps_mat_t{i}(:,3);
    h1 = scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
    
    oc_x = OC1(i,1);
    oc_y = OC1(i,2);
    oc_z = OC1(i,3);
    h2 = scatter3(oc_x,oc_y,oc_z,'filled','MarkerFaceColor',[0 0 1]);
    axis([-10 10 -10 10 -1 30]);
%     axis([-10 10 -10 10 8 18]);
    drawnow
    pause(0.1);
    set(h1,'Visible','off');
    set(h2,'Visible','off');
end
hold off;