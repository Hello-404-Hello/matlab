[t,c]=advance(.04);
[~,f]=advance(.02);
y=(4*f(1:2:end,:)-c)/3;
u=y(end,2);
g=9.8; drag=.4/320;
alpha=atan(sqrt(drag/g)*u);
s=linspace(0,alpha/sqrt(g*drag),350)';
v=sqrt(g/drag)*tan(alpha-s*sqrt(g*drag));
h=y(end,1)+log(cos(alpha-s*sqrt(g*drag))/cos(alpha))/drag;
a=accel(t,y(:,2));
b=-g-drag*v.^2;
disp([y(end,:),a(end),b(1),60+s(end),h(end)])
figure
tiledlayout(1,3)
nexttile; plot([t;60+s],[y(:,1);h]); xlabel('时间'); ylabel('高度')
nexttile; plot([t;60+s],[y(:,2);v]); xlabel('时间'); ylabel('速度')
nexttile; plot([t;60+s],[a;b]); xlabel('时间'); ylabel('加速度')

function [t,y]=advance(dt)
t=(0:dt:60)';
y=zeros(numel(t),2);
for j=1:numel(t)-1
    v=y(j,2);
    a=accel(t(j),v);
    b=accel(t(j+1),v+a*dt);
    w=v+dt*(a+b)/2;
    y(j+1,:)=[y(j,1)+dt*(v+w)/2,w];
end
end

function x=accel(t,v)
x=(32000-.4*v.*abs(v))./(1400-18*t)-9.8;
end
