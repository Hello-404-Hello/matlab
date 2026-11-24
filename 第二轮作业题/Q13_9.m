dt=.01;
t=0:dt:60;
v=zeros(size(t));
h=v;
for j=1:numel(t)-1
    m=1400-18*(t(j)+dt/2);
    a0=32000/m-9.8;
    u=v(j)+a0*dt/2;
    u=u/(1+dt*.4*abs(u)/m);
    v(j+1)=u+a0*dt/2;
    h(j+1)=h(j)+dt*(v(j)+v(j+1))/2;
end
k=.4/320;
q=sqrt(9.8/k);
p=atan(v(end)/q);
tmax=p/sqrt(9.8*k);
s=linspace(0,tmax);
z=p-s*sqrt(9.8*k);
v2=q*tan(z);
h2=h(end)+log(cos(z)/cos(p))/k;
a=(32000-.4*v.^2)./(1400-18*t)-9.8;
a2=-9.8-k*v2.^2;
fprintf('%.6f %.6f\n',h(end),v(end))
fprintf('%.6f %.6f\n',a(end),a2(1))
fprintf('%.6f %.6f\n',60+tmax,h2(end))
figure
subplot(2,2,1); plot(t,h,60+s,h2); ylabel('高度')
subplot(2,2,2); plot(t,v,60+s,v2); ylabel('速度')
subplot(2,2,[3,4]); plot([t,60+s],[a,a2]); ylabel('加速度')
