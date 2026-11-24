g=9.8;
k=.4/320;
s=linspace(0,log(1400/320),501)';
opt=odeset('RelTol',1e-9,'AbsTol',1e-9);
[s,y]=ode45(@(s,y)stage(s,y),s,[0;0],opt);
m=1400*exp(-s);
t=(1400-m)/18;
v0=y(end,2);
h0=y(end,1);
a1=(32000-.4*v0^2)/320-g;
a2=-g-k*v0^2;
dv=linspace(v0,0,230)';
t2=t(end)+arrayfun(@(u)integral(@(v)1./(g+k*v.^2),u,v0),dv);
h=h0+arrayfun(@(u)integral(@(v)v./(g+k*v.^2),u,v0),dv);
fprintf('关机 %.2f m，%.3f m/s\n',h0,v0)
fprintf('切断前后 %.5f，%.5f m/s²\n',a1,a2)
fprintf('顶点 %.3f s，%.2f m\n',t2(end),h(end))
a=(32000-.4*y(:,2).^2)./m-g;
figure
x=[t;t2];
ax=axes('Position',[.14,.72,.79,.20]); line(ax,x,[y(:,1);h]); ylabel(ax,'高度')
ax=axes('Position',[.14,.42,.79,.20]); line(ax,x,[y(:,2);dv]); ylabel(ax,'速度')
ax=axes('Position',[.14,.12,.79,.20]); line(ax,x,[a;-g-k*dv.^2]); ylabel(ax,'加速度')
xlabel('时间')

function z=stage(s,y)
m=1400*exp(-s);
v=y(2);
a=(32000-.4*v*abs(v))/m-9.8;
z=(m/18)*[v;a];
end
