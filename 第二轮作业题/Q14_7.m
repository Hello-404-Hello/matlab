g=9.8;
theta=25;
h=1.5;
mu=.27;
[a,b,c]=traj(g,theta,h,mu);
figure
tiledlayout(2,1)
p=nexttile;
toe=h/tand(theta);
line(p,[0,toe,b(end)+1],[h,0,0],'LineWidth',2)
hold(p,'on')
obj=plot(p,b(1),c(1),'o','MarkerSize',10,'MarkerFaceColor','auto');
axis(p,[-.4,b(end)+.7,-.3,h+.4])
q=nexttile;
line(q,a,b)
hold(q,'on')
mark=plot(q,a(1),b(1),'o');
xlabel(q,'t')
ylabel(q,'x')
for j=1:numel(a)
    obj.XData=b(j);
    obj.YData=c(j);
    mark.XData=a(j);
    mark.YData=b(j);
    drawnow limitrate
    pause(.013)
end
disp([a(end),b(end)])

function [t,x,y]=traj(g,theta,h,mu)
l=h/sind(theta);
u=sqrt(2*g*h);
a=g*sind(theta);
t1=u/a;
ti=linspace(0,t1,61);
d=.5*a*ti.^2;
tf=linspace(0,u/(g*mu),61);
s=u*tf-.5*g*mu*tf.^2;
t=[ti,t1+tf(2:end)];
x=[d*cosd(theta),l*cosd(theta)+s(2:end)];
y=[h-d*sind(theta),zeros(1,60)];
end
