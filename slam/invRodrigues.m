function r = invRodrigues(R)
% invRodrigues
% Input:
%   R: 3x3 rotation matrix
% Output:
%   r: 3x1 vector
A = (R-R')/2;
rho = [A(3,2); A(1,3); A(2,1)];
s = norm(rho);
c = (R(1,1)+R(2,2)+R(3,3)-1)/2;
if s==0
    if c==1
        r=zeros(3,1);
    elseif c==-1
        V = R+eye(3);
        v = V(:,find(any(V),1));
        u = v/norm(v);
        r = pi*u;
        if norm(r)==pi && ((r(1)==r(2)&&r(2)==0&&r(3)<0) || (r(1)==0&&r(2)<0) || (r(1)<0))
           r = -r; 
        end
    end
else
    u = rho/s;
    theta = atan2(s,c);
    r = u*theta;
end
end
