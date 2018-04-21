x = cos(linspace(1,36,50)) + 1;
y = sin(linspace(1,36,50)) + 1;
z = ones(1,50);

Ps = zeros(4, 150);
Ps(1, 1:3:end) = x; Ps(1, 2:3:end) = y; Ps(1, 3:3:end) = z;
Ps(2, 1:3:end) = x; Ps(2, 2:3:end) = y; Ps(2, 3:3:end) = z;
Ps(3, 1:3:end) = x; Ps(3, 2:3:end) = y; Ps(3, 3:3:end) = z;
Ps(4, 1:3:end) = x; Ps(4, 2:3:end) = y; Ps(4, 3:3:end) = z;
Ps = mat2cell(Ps, 4, 3*ones(1,50));

t_start = 3; t_end = 7;
minPeakDis=0; minPeakHei=0;
[Ps_mat_t, Period] = LocalizePointPCA(Ps, t_start, t_end, minPeakDis, minPeakHei);