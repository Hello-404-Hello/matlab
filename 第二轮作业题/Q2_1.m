t=linspace(0,2*pi,361);
v=[1,1,1;1,-1,-1;-1,1,-1;-1,-1,1];
f=[1,2,3;1,2,4;1,3,4;2,3,4];
figure
subplot(2,2,1)
plot(cos(t),sin(t),'m','LineWidth',2)
axis equal
title('圆')
subplot(2,2,2)
plot(2*cos(t),sin(t),'Color',[.55,0,.6])
axis equal
set(gca,'LineWidth',2,'FontSize',14)
title('椭圆')
subplot(2,2,3)
trisurf(f,v(:,1),v(:,2),v(:,3))
axis equal
title('正四面体')
subplot(2,2,4)
[x,y,z]=cylinder([1,0],60);
surf(x,y,2*z)
axis equal
title('圆锥')
