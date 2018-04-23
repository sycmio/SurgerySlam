close all;
N = length(Ps_mat_t);

f1 = figure;

hold on;
% draw 3d points and camera position over time
for i = 1:N
    x = Ps_mat_t{i}(:,1);
    y = Ps_mat_t{i}(:,2);
    z = Ps_mat_t{i}(:,3);
    h1 = scatter3(x,y,z,'filled','MarkerFaceColor',[1 0 0]);
    
    oc_x_sofar = OC1(1:i,1);
    oc_y_sofar = OC1(1:i,2);
    oc_z_sofar = OC1(1:i,3);
    h2 = plot3(oc_x_sofar,oc_y_sofar,oc_z_sofar,'Color',[0 0 1]);
    
    oc_x = OC1(i,1);
    oc_y = OC1(i,2);
    oc_z = OC1(i,3);
    h3 = scatter3(oc_x,oc_y,oc_z,'filled','MarkerFaceColor',[0 1 0]);
    
    oc_x_sofar_bad = OC1_bad(1:i,1);
    oc_y_sofar_bad = OC1_bad(1:i,2);
    oc_z_sofar_bad = OC1_bad(1:i,3);
    h4 = plot3(oc_x_sofar_bad,oc_y_sofar_bad,oc_z_sofar_bad,'Color',[0 0 0]);
    
    oc_x_bad = OC1_bad(i,1);
    oc_y_bad = OC1_bad(i,2);
    oc_z_bad = OC1_bad(i,3);
    h5 = scatter3(oc_x_bad,oc_y_bad,oc_z_bad,'filled','MarkerFaceColor',[0.6 0.5 0.2]);
    
    axis([-10 10 -10 10 -1 30]);
%     axis([-10 10 -10 10 8 18]);
    drawnow
    pause(0.1);
    set(h1,'Visible','off');
    set(h2,'Visible','off');
    set(h3,'Visible','off');
    set(h4,'Visible','off');
    set(h5,'Visible','off');
end
hold off;

f2 = figure;
hold on;
for i = 1:N    
    oc_x_sofar = OC1(1:i,1);
    oc_y_sofar = OC1(1:i,2);
    oc_z_sofar = OC1(1:i,3);
    h1 = plot3(oc_x_sofar,oc_y_sofar,oc_z_sofar,'Color',[0.2 0.4 0.6]);
    
    oc_x = OC1(i,1);
    oc_y = OC1(i,2);
    oc_z = OC1(i,3);
    h2 = scatter3(oc_x,oc_y,oc_z,'filled','MarkerFaceColor',[0.1 0.7 0.4]);
    
    axis([-10 10 -10 10 -1 30]);
    drawnow
    pause(0.1);
    set(h1,'Visible','off');
    set(h2,'Visible','off');
end
hold off;