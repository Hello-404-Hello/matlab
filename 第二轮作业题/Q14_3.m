g=9.8; deg=22; h=1.65; mu=.31;
l=h/sind(deg);
speed=0;
s=0;
dt=.025;
a=g*sind(deg);
x=[]; y=[];
while s<l
    x(end+1)=s*cosd(deg);
    y(end+1)=h-s*sind(deg);
    s=s+speed*dt+a*dt^2/2;
    speed=speed+a*dt;
end
speed=sqrt(2*g*h);
endx=l*cosd(deg)+speed^2/(2*g*mu);
s=l*cosd(deg);
while speed>0
    x(end+1)=s; y(end+1)=0;
    step=min(dt,speed/(g*mu));
    s=s+speed*step-g*mu*step^2/2;
    speed=max(0,speed-g*mu*step);
end
x(end+1)=endx; y(end+1)=0;
figure
plot([0,l*cosd(deg),endx+.5],[h,0,0],'Color',[.25,.25,.25])
hold on
axis([-.2,endx+.55,-.18,h+.3])
trace=animatedline('Color',[.20,.55,.65]);
q=plot(x(1),y(1),'p','MarkerSize',13,'MarkerFaceColor',[.2,.55,.65]);
for k=1:numel(x)
    addpoints(trace,x(k),y(k))
    q.XData=x(k); q.YData=y(k);
    drawnow limitrate
    pause(.012)
end
disp(endx)
