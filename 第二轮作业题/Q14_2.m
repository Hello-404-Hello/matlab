len=3; angle=30; friction=.25;
g=9.8;
t=sqrt(2*len/(g*sind(angle)));
v=g*sind(angle)*t;
s=v^2/(2*g*friction);
endpoint=[len*cosd(angle),0];
canvas=figure('Color','w');
ax=axes(canvas);
plot(ax,[0,endpoint(1),endpoint(1)+s+1],[len*sind(angle),0,0],'Color',[.2,.38,.52])
hold(ax,'on')
axis(ax,'equal')
axis(ax,[-.5,endpoint(1)+s+1,-.5,2.2])
shape=[-.16,0;.16,0;.16,.28;-.16,.28];
body=patch(ax,shape(:,1),shape(:,2),[.98,.57,.14]);
sam=linspace(0,t,55);
for k=1:55
    d=.5*g*sind(angle)*sam(k)^2;
    a=[cosd(angle),-sind(angle);sind(angle),cosd(angle)];
    vtx=shape*a+[d*cosd(angle),(len-d)*sind(angle)];
    set(body,'XData',vtx(:,1),'YData',vtx(:,2))
    pause(.024)
end
for k=linspace(0,v/(g*friction),65)
    h=v*k-g*friction*k^2/2;
    vtx=shape+endpoint+[h,0];
    set(body,'XData',vtx(:,1),'YData',vtx(:,2))
    pause(.024)
end
disp([endpoint(1),s])
