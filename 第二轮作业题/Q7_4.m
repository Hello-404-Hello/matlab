p=[.6,-.9];
s=.1;
for k=1:10
    [a,b]=meshgrid(p(1)+(-5:5)*s,p(2)+(-5:5)*s);
    c=exp(2*a).*(a+b.^2+2*b);
    [z,i]=min(c,[],'all','linear');
    p=[a(i),b(i)];
    s=s/4;
end
disp([p,z])
