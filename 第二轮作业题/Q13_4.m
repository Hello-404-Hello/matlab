dt=.02;
t=0:dt:60;
v=zeros(size(t)); h=v;
for i=1:numel(t)-1
    a=(32000-.4*v(i)^2)/(1400-18*t(i))-9.8;
    v1=v(i)+a*dt;
    b=(32000-.4*v1^2)/(1400-18*t(i+1))-9.8;
    v(i+1)=v(i)+(a+b)*dt/2;
    h(i+1)=h(i)+(v(i)+v(i+1))*dt/2;
end
j=numel(t);
while v(end)>0
    u=v(end);
    a=-9.8-.00125*u^2;
    b=-9.8-.00125*(u+a*dt)^2;
    v1=u+(a+b)*dt/2;
    step=dt;
    if v1<0
        step=dt*u/(u-v1);
        v1=0;
    end
    t(end+1)=t(end)+step;
    h(end+1)=h(end)+(u+v1)*step/2;
    v(end+1)=v1;
end
ac1=(32000-.4*v(1:j).^2)./(1400-18*t(1:j))-9.8;
ac2=-9.8-.00125*v(j:end).^2;
disp([h(j),v(j),ac1(end),ac2(1),t(end),h(end)])
figure
tiledlayout(2,2)
nexttile; plot(t,h,'k'); title('h')
nexttile; plot(t,v,'b'); title('v')
nexttile([1,2]); stairs([t(1:j),t(j:end)],[ac1,ac2],'r'); title('a')
