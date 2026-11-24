h=1.4;
s=3.1;
l=hypot(s,h);
a=9.8*h/l;
friction=.32*9.8;
vx=sqrt(2*a*l);
t1=vx/a;
t2=vx/friction;
figure
axis([-.4,s+vx*t2/2+.7,-.35,h+.45])
axis equal manual
hold on
fill([0,s,0],[0,0,h],[.91,.91,.91])
plot([s,s+vx*t2/2+.5],[0,0],'k')
b=rectangle('Position',[0,h,.30,.25],'Curvature',.15);
for j=0:120
    t=j*(t1+t2)/120;
    if t<t1
        dx=.5*a*t^2/l;
        p=[s*dx,h*(1-dx)];
    else
        dt=t-t1;
        p=[s+dt*(vx-.5*friction*dt),0];
    end
    b.Position=[p(1),p(2),.30,.25];
    title(sprintf('%.2f s',t))
    drawnow limitrate
    pause(.012)
end
disp([t1+t2,p(1)])
