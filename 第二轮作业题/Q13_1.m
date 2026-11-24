tb=60; m=320; g=9.8; c=.4;
pow=@(t,y)[y(2);(32000-c*y(2)*abs(y(2)))/(1400-18*t)-g];
coast=@(~,y)[y(2);-g-c*y(2)*abs(y(2))/m];
opt=odeset('RelTol',1e-9,'AbsTol',1e-10);
[t,u]=ode45(pow,[0,tb],[0,0],opt);
[v,w]=ode45(coast,[tb,160],u(end,:),odeset(opt,'Events',@peak));
aa=(32000-c*u(:,2).*abs(u(:,2)))./(1400-18*t)-g;
ab=-g-c*w(:,2).*abs(w(:,2))/m;
disp([u(end,:),aa(end),ab(1),v(end),w(end,1)])
figure
tiledlayout(3,1)
nexttile; plot([t;v],[u(:,1);w(:,1)])
nexttile; plot([t;v],[u(:,2);w(:,2)])
nexttile; plot([t;v],[aa;ab])

function [v,stop,dir]=peak(~,y)
v=y(2);
stop=1;
dir=-1;
end
