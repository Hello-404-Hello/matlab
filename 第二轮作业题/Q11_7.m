figure
hold on
piece(2.1,.58,.04,2.88,[.39,.67,.80])
piece(.58,.58,2.88,4.65,[.39,.67,.80])
piece(.50,.50,4.65,2.87,[.49,.72,.85])
piece(.50,1.93,2.87,.19,[.49,.72,.85])
piece(1.93,0,.19,.19,[.49,.72,.85])
piece(2.1,0,.04,.04,[.39,.67,.80])
piece(.50,.58,4.65,4.65,[.29,.55,.67])
view(-40,21)
axis equal
camlight
lighting gouraud

function piece(r,s,z,w,c)
[x,y,t]=cylinder([r,s],60);
p=surf2patch(x,y,z+(w-z)*t,'triangles');
patch(p,'FaceColor',c,'FaceAlpha',.44,'EdgeColor','none');
end
