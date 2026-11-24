a=readmatrix('pt.xlsx');
x=a(:,2); y=a(:,3); z=a(:,4);
b=[x,y,ones(size(x))]\z;
q=[b(1),b(2),-1,b(3)];
q=-q/norm(q(1:3));
h=3*b(1)-2*b(2)+b(3);
disp(q)
disp(h)
[u,v]=meshgrid(linspace(min([x;3]),max(x)),linspace(-2,max(y)));
figure
surf(u,v,b(1)*u+b(2)*v+b(3),'FaceAlpha',.5,'EdgeColor','none')
hold on
scatter3(x,y,z,28,'k','filled')
plot3(3,-2,h,'rp','MarkerFaceColor','r','MarkerSize',14)
xlabel('x'); ylabel('y'); zlabel('z')
