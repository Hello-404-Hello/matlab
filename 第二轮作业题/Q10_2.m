pair=[267,36];
a=pair(1);
b=pair(2);
u=[abs(a),1,0];
v=[abs(b),0,1];
while v(1)~=0
    t=u-floor(u(1)/v(1))*v;
    u=v;
    v=t;
end
disp([u(2)*sign(a),u(3)*sign(b),u(1)])
