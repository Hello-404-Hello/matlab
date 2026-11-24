figure('Position',[120,180,860,500])
axes('Position',[.06,.59,.36,.32])
fimplicit(@(x,y)x.^2+y.^2-1,[-1.2,1.2],'m','LineWidth',2)
axis equal
axes('Position',[.51,.62,.43,.27])
fimplicit(@(x,y)x.^2/4+y.^2-1,[-2.2,2.2,-1.2,1.2],'Color',[.45,.12,.62])
axis equal
set(gca,'LineWidth',2,'FontSize',14)
axes('Position',[.08,.06,.39,.43])
p=[0,0,0;2,0,0;1,sqrt(3),0;1,sqrt(3)/3,sqrt(8/3)];
e=nchoosek(1:4,2);
hold on
for u=1:6
    s=p(e(u,:),:);
    plot3(s(:,1),s(:,2),s(:,3),'k')
end
axis equal
view(3)
axes('Position',[.53,.08,.34,.38])
fsurf(@(a,k)k.*cos(a),@(a,k)k.*sin(a),@(a,k)2-2*k,[0,2*pi,0,1])
axis equal
