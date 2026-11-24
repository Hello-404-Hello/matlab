L=4; theta=pi/7; mu=.22; g=9.8;
a=g*sin(theta);
u=sqrt(2*a*L);
t1=u/a;
t2=u/(mu*g);
figure
plot([0,L*cos(theta),L*cos(theta)+u*t2],[L*sin(theta),0,0],'k','LineWidth',2)
hold on
p=plot(0,L*sin(theta),'rs','MarkerFaceColor','r','MarkerSize',10);
axis([-.3,L*cos(theta)+u*t2+.3,-.25,L*sin(theta)+.4])
for t=linspace(0,t1+t2,100)
    if t<t1
        s=.5*a*t*t;
        x=s*cos(theta); y=(L-s)*sin(theta);
    else
        j=t-t1;
        x=L*cos(theta)+u*j-.5*mu*g*j*j; y=0;
    end
    set(p,'XData',x,'YData',y)
    drawnow limitrate
    pause(.02)
end
disp([t1,t2,u^2/(2*mu*g)])
