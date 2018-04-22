N = 100;

hold on;
for i=1:N
    x = Ps{i}(:,1);
    y = Ps{i}(:,2);
    z = Ps{i}(:,3);
    h1 = scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
    
    x = Ps_mat_t{i}(:,1);
    y = Ps_mat_t{i}(:,2);
    z = Ps_mat_t{i}(:,3);
    h2 = scatter3(x,y,z,'filled','MarkerFaceColor',[0 1 0]);
    axis([-10 10 -10 10 20 30]);
    
    drawnow
    pause(0.1);
    set(h1,'Visible','off');
    set(h2,'Visible','off');
end
hold off;