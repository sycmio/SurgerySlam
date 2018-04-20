% plot point x/y/z positions over time

point_index = 10;
N = length(Ps);

x = zeros(1,N);
y = zeros(1,N);
z = zeros(1,N);

time = 1:N;

for i = 1:N
    x(i) = Ps{i}(point_index,1);
    y(i) = Ps{i}(point_index,2);
    z(i) = Ps{i}(point_index,3);
end
figure('Name','X');
plot(time,x);
figure('Name','Y');
plot(time,y);
figure('Name','Z');
plot(time,z);

hold off;