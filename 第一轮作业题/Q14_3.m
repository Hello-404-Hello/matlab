step=[0.02,0.01,0.005];
result=zeros(numel(step),2);
for j=1:numel(step)
    h=step(j);
    unit=round(1/h);
    last=round(500/h);
    e=zeros(last+1,1);
    integralE=zeros(last+1,1);
    e(unit+1)=1;
    for n=unit+1:last
        x=n*h;
        e(n+1)=1+2*integralE(n-unit+1)/(x-1);
        integralE(n+1)=integralE(n)+h*(e(n)+e(n+1))/2;
    end
    result(j,:)=[h,e(end)];
end
disp(result)
disp(abs(diff(result(:,2))))
