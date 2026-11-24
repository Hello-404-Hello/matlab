g=9.8; s=3.8; h=1.9; mu=.3;
l=hypot(s,h);
a=g*h/l;
z=sqrt(2*l/a);
[x,u]=ode45(@(~,v)[v(2);a],linspace(0,z,65),[0;0]);
flat=u(end,2)/(g*mu);
[y,w]=ode45(@(~,v)[v(2);-g*mu],linspace(0,flat,70),[0;u(end,2)]);
xpos=[s*u(:,1)/l;s+w(2:end,1)];
ypos=[h*(1-u(:,1)/l);zeros(length(y)-1,1)];
tm=[x;z+y(2:end)];
figure
plot([0,s,xpos(end)+.5],[h,0,0],'k-')
hold on
axis([-.6,xpos(end)+.6,-.3,h+.55])
sq=fill([0,0,0,0],[0,0,0,0],[.5,.6,.8]);
histx=animatedline('LineStyle',':');
for k=1:numel(tm)
    sx=[-.14,.14,.14,-.14];
    sy=[0,0,.25,.25];
    deg=-atan2(h,s)*(k<=numel(x));
    sq.XData=xpos(k)+sx*cos(deg)-sy*sin(deg);
    sq.YData=ypos(k)+sx*sin(deg)+sy*cos(deg);
    addpoints(histx,xpos(k),ypos(k));
    title(sprintf('t = %.2f s',tm(k)))
    drawnow limitrate
    pause(.012)
end
disp([z,flat,xpos(end)-s])
