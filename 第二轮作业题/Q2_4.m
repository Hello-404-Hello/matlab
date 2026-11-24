figure('Position',[120,120,740,620])
ax=subplot(2,2,1);
oval(ax,1,1,'m',2)
ax=subplot(2,2,2);
oval(ax,2.5,1.3,[.60,.15,.72],1.3)
set(ax,'LineWidth',2,'FontSize',14)
ax=subplot(2,2,3);
p=[1,1,1;-1,-1,1;-1,1,-1;1,-1,-1];
k=[1,2,3;1,2,4;1,3,4;2,3,4];
patch(ax,'Vertices',p,'Faces',k,'FaceVertexCData',(1:4)','FaceColor','flat')
axis(ax,'equal')
view(ax,3)
ax=subplot(2,2,4);
u=linspace(0,2*pi,100);
fill3(ax,cos(u),sin(u),zeros(size(u)),[.82,.65,.29])
hold(ax,'on')
mesh(ax,[cos(u);zeros(size(u))],[sin(u);zeros(size(u))],[zeros(size(u));2*ones(size(u))])
axis(ax,'equal')
view(ax,3)

function oval(ax,a,b,c,d)
u=(0:2:360)*pi/180;
plot(ax,a*cos(u),b*sin(u),'Color',c,'LineWidth',d)
axis(ax,'equal')
grid(ax,'on')
end
