[x,y,z]=meshgrid(linspace(-2.35,2.35,77),linspace(-2.35,2.35,77),linspace(-.12,4.82,82));
r=hypot(x,y);
ro=interp1([0,.14,2.55,2.96,4.55,4.64],[2.10,2.10,.76,.55,.55,.62],z,'linear','extrap');
ri=interp1([.13,2.51,2.94,4.64],[1.94,.63,.46,.49],z,'linear','extrap');
cavity=min(z-.13,ri-r);
shape=max(max(r-ro,-cavity),max(-z,z-4.64));
figure
p=patch(isosurface(x,y,z,shape,0));
isonormals(x,y,z,shape,p)
set(p,'FaceColor',[.61,.82,.88],'FaceAlpha',.55,'EdgeColor','none')
axis equal tight
view(40,26)
light
lighting gouraud
