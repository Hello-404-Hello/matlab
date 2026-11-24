t=readtable('pt.xlsx');
p=t{:,2:4};
o=mean(p,1);
[~,~,w]=svd(p-o,0);
n=w(:,end)';
if n(3)<0
    n=-n;
end
d=-dot(o,n);
height=-(dot(n(1:2),[3,-2])+d)/n(3);
fprintf('%.7f %.7f %.7f %.7f\n',n,d)
disp(height)
figure('Color','w')
corners=[min(p(:,1)), -2;max(p(:,1)), -2;max(p(:,1)),max(p(:,2));min(p(:,1)),max(p(:,2))];
pz=-(corners*n(1:2)'+d)/n(3);
patch(corners(:,1),corners(:,2),pz,[.24,.67,.83],'FaceAlpha',.4)
hold on
plot3(p(:,1),p(:,2),p(:,3),'k.')
plot3(3,-2,height,'p','MarkerSize',15,'MarkerEdgeColor',[.5,0,.5],'MarkerFaceColor',[1,.8,.15])
grid on
view(28,20)
