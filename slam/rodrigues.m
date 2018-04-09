function R = rodrigues(r)
% rodrigues:

% Input:
%   r - 3x1 vector
% Output:
%   R - 3x3 rotation matrix
theta = norm(r);
if theta==0
    R = eye(3);
else
    u = r/theta;
    u_x = [0 -u(3) u(2); u(3) 0 -u(1); -u(2) u(1) 0];
    R = eye(3)*cos(theta)+(1-cos(theta))*(u*u')+u_x*sin(theta);
end
end
