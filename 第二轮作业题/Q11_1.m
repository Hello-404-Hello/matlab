z=[0,.15,2.9,3.25,4.8,4.94,4.94,3.22,2.92,.18,.18];
r=[0,2.05,.65,.52,.52,.60,.44,.44,.56,1.88,0];
[x,y,~]=cylinder(r,96);
zz=repmat(z',1,size(x,2));
figure
surf(x,y,zz,'FaceColor',[.54,.83,.90],'EdgeColor','none','FaceAlpha',.53)
axis equal
view(38,21)
camlight
lighting gouraud
