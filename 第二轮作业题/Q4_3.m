data=readmatrix('pt.xlsx');
p=data(:,2:4);
coef=plane(p);
z0=-(3*coef(1)-2*coef(2)+coef(4))/coef(3);
disp([coef',z0])
figure
fsurf(@(x,y)-(coef(1)*x+coef(2)*y+coef(4))/coef(3),[0,max(p(:,1)), -2,max(p(:,2))])
hold on
plot3(p(:,1),p(:,2),p(:,3),'.k')
plot3(3,-2,z0,'kp','MarkerSize',13,'MarkerFaceColor','y')
view(3)

function b=plane(p)
m=mean(p);
u=p-m;
[v,w]=eig(u'*u,'vector');
[~,i]=min(w);
a=v(:,i);
if a(3)<0
    a=-a;
end
b=[a;-m*a];
end
