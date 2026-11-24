f=readcell('pt.xlsx');
p=cell2mat(f(2:end,2:4));
u=[p(:,1:2),ones(size(p,1),1)];
[q,r]=qr(u,0);
s=r\(q'*p(:,3));
v=[-s(1:2);1;-s(3)];
v=v/norm(v(1:3));
out=[[3,-2,1]*s;v];
disp(out')
[a,b]=meshgrid([0,3,max(p(:,1))],[-2,0,max(p(:,2))]);
figure
mesh(a,b,s(1)*a+s(2)*b+s(3))
hold on
plot3(3,-2,out(1),'gp','MarkerFaceColor','g','MarkerSize',15)
scatter3(p(:,1),p(:,2),p(:,3),20,'filled')
axis tight
view(45,30)
