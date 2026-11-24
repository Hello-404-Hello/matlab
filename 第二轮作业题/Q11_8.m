figure
hold on
polarpart(0,.15,2.35,2.35)
polarpart(.15,2.9,2.35,.52)
polarpart(2.9,4.8,.52,.52)
polarpart(4.8,4.8,.52,.43)
polarpart(4.8,2.87,.43,.43)
polarpart(2.87,.19,.43,2.13)
polarpart(.19,.19,2.13,0)
polarpart(0,0,2.35,0)
axis equal
view(55,18)
title('直口三角烧瓶')

function polarpart(a,b,c,d)
[t,s]=meshgrid(linspace(0,2*pi,41),linspace(0,1,7));
r=c+(d-c)*s;
h=a+(b-a)*s;
mesh(r.*cos(t),r.*sin(t),h,'FaceAlpha',.30,'EdgeAlpha',.23)
end
