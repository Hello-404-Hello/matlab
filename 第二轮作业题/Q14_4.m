angle=pi/5; L=3.5; m=.28; g=9.8;
acc=g*sin(angle);
[t,z]=ode45(@(~,q)[q(2);acc],[0,sqrt(2*L/acc)],[0;0]);
s=linspace(0,z(end,2)/(g*m),70);
d=z(end,2)*s-g*m*s.^2/2;
xx=[z(:,1)'*cos(angle),L*cos(angle)+d];
yy=[(L-z(:,1)')*sin(angle),zeros(size(s))];
vv=[z(:,2)',z(end,2)-g*m*s];
figure
tiledlayout(2,1)
a=nexttile;
plot(a,[0,L*cos(angle),xx(end)+.5],[L*sin(angle),0,0],'LineWidth',2)
hold(a,'on')
p=scatter(a,0,yy(1),80,[.74,.2,.26],'filled','s');
axis(a,[-.3,xx(end)+.6,-.25,yy(1)+.3])
b=nexttile;
xt=linspace(0,t(end),35);
vt=interp1(t,z(:,2),xt);
plot(b,[xt,t(end)+s],[vt,z(end,2)-g*m*s])
hold(b,'on')
q=plot(b,0,0,'or');
time=[t',t(end)+s];
for k=1:numel(xx)
    set(p,'XData',xx(k),'YData',yy(k))
    set(q,'XData',time(k),'YData',vv(k))
    drawnow limitrate
    pause(.015)
end
disp([t(end)+s(end),xx(end)])
