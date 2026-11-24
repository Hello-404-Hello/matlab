figure('Color','w')
hold on
ring(0,2.4,2.7,.65)
ring(2.7,.65,3.1,.50)
ring(3.1,.50,4.8,.50)
ring(4.8,.50,4.8,.42)
ring(4.8,.42,3.08,.42)
ring(3.08,.42,2.68,.57)
ring(2.68,.57,.18,2.19)
ring(.18,2.19,.18,0)
ring(0,2.4,0,0)
axis equal off
view(125,19)

function ring(h,a,k,b)
u=(0:90)*2*pi/90;
surf([a;b]*cos(u),[a;b]*sin(u),[h;k]*ones(size(u)),'FaceAlpha',.52,'EdgeColor','none','FaceColor',[.25,.68,.62])
end
