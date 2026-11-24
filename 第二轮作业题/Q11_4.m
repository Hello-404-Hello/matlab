z=[0,.05,.15,2.7,3.1,4.5];
r=[0,2.2,2.2,.7,.55,.55];
zi=[.17,.17,2.68,3.08,4.5];
ri=[0,2.02,.59,.47,.47];
figure
hold on
u=linspace(0,2*pi,55);
shell(z,r,u,[.71,.56,.82])
shell(zi,ri,u,[.76,.65,.87])
shell([4.5,4.5],[.47,.55],u,[.45,.23,.55])
axis equal
view(-36,16)
grid on

function shell(z,r,t,c)
h=linspace(1,numel(z),100);
a=interp1(1:numel(z),r,h,'linear')';
b=interp1(1:numel(z),z,h,'linear')';
mesh(a*cos(t),a*sin(t),repmat(b,1,numel(t)),'FaceColor',c,'EdgeAlpha',.15,'FaceAlpha',.60)
end
