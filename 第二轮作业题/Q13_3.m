tol=odeset('RelTol',1e-9,'AbsTol',1e-9);
f=@(t,v)(32000-.4*v.^2)./(1400-18*t)-9.8;
m=ode113(f,[0,60],0,tol);
t=linspace(0,60,601);
v=deval(m,t);
h=arrayfun(@(u)integral(@(s)deval(m,s),0,u),t);
g=@(~,w)-9.8-.00125*w.*abs(w);
p=ode113(g,[60,140],v(end),tol);
ta=fzero(@(s)deval(p,s),[60,140]);
s=linspace(60,ta,250);
z=deval(p,s);
hu=h(end)+arrayfun(@(u)integral(@(q)deval(p,q),60,u),s);
disp([h(end),v(end),f(60,v(end)),g(60,v(end)),ta,hu(end)])
figure('Color','w')
subplot(1,3,1); plot([t,s],[h,hu]); title('高度')
subplot(1,3,2); plot([t,s],[v,z],'Color',[.2,.6,.35]); title('速度')
subplot(1,3,3); plot([t,s],[f(t,v),g(s,z)]); title('加速度')
