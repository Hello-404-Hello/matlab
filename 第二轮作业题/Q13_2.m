h=.025;
t=(0:h:60)';
y=zeros(numel(t),2);
for i=1:numel(t)-1
    v=y(i,:);
    a=rhs(t(i),v);
    b=rhs(t(i)+h/2,v+h*a/2);
    c=rhs(t(i)+h/2,v+h*b/2);
    d=rhs(t(i)+h,v+h*c);
    y(i+1,:)=v+h*(a+2*b+2*c+d)/6;
end
g=9.8; k=.4/320;
p=atan(y(end,2)*sqrt(k/g));
dt=p/sqrt(g*k);
s=linspace(0,dt,400)';
u=p-sqrt(g*k)*s;
hh=y(end,1)+log(cos(u)/cos(p))/k;
vv=sqrt(g/k)*tan(u);
aa=(32000-.4*y(:,2).^2)./(1400-18*t)-g;
az=-g-k*vv.^2;
disp([y(end,:),aa(end),az(1),60+dt,hh(end)])
figure
subplot(3,1,1); plot(t,y(:,1),60+s,hh,'--'); ylabel('m')
subplot(3,1,2); plot(t,y(:,2),60+s,vv,'--'); ylabel('m/s')
subplot(3,1,3); plot([t;60+s],[aa;az]); ylabel('m/s²')

function q=rhs(t,p)
v=p(2);
q=[v,(32000-.4*v*abs(v))/(1400-18*t)-9.8];
end
