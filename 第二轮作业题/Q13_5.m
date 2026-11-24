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
disp([h0,v0,a1,a2,t2(end),h(end)])
a=(32000-.4*y(:,2).^2)./m-g;
figure
tiledlayout(3,1)
nexttile; plot([t;t2],[y(:,1);h]); ylabel('高度')
nexttile; plot([t;t2],[y(:,2);dv]); ylabel('速度')
nexttile; plot([t;t2],[a;-g-k*dv.^2]); ylabel('加速度')
xlabel('时间')

function z=stage(s,y)
m=1400*exp(-s);
v=y(2);
a=(32000-.4*v*abs(v))/m-9.8;
z=(m/18)*[v;a];
end
