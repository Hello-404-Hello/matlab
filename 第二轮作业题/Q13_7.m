step=.01;
t=0:step:60;
h=zeros(size(t)); v=h;
for i=1:length(t)-1
    now=v(i);
    a=force(t(i),now);
    mid=now+a*step/2;
    v(i+1)=now+step*force(t(i)+step/2,mid);
    h(i+1)=h(i)+step*mid;
end
off=numel(t);
while v(end)>0
    t(end+1)=t(end)+step;
    now=v(end);
    mid=now-step*(9.8+now^2/800)/2;
    v(end+1)=now-step*(9.8+mid^2/800);
    h(end+1)=h(end)+step*mid;
end
r=v(end-1)/(v(end-1)-v(end));
t(end)=t(end-1)+r*step;
h(end)=h(end-1)+r*(h(end)-h(end-1));
v(end)=0;
a=force(t(1:off),v(1:off));
b=-9.8-v(off:end).^2/800;
fprintf('%.6f %.6f %.6f %.6f %.6f %.6f\n',h(off),v(off),a(end),b(1),t(end),h(end))
figure
subplot(3,1,1); plot(t,h); title('高度')
subplot(3,1,2); plot(t,v); title('速度')
subplot(3,1,3); plot([t(1:off),t(off:end)],[a,b]); title('加速度')

function a=force(t,v)
a=(32000-.4*v.*abs(v))./(1400-18*t)-9.8;
end
