p=readmatrix('Temp2.xlsx');
n=size(p,1);
k=-50:50;
r=zeros(size(k));
for j=1:numel(k)
    h=k(j);
    if h<0
        a=p(1-h:n,1); b=p(1:n+h,2);
    else
        a=p(1:n-h,1); b=p(1+h:n,2);
    end
    c=corrcoef(a,b);
    r(j)=c(1,2);
end
[~,i]=max(r);
lag=k(i);
disp([1+(lag<0),lag,5/abs(lag)])
figure('Color','w')
plot((0:n-1)/100,p(:,1),'LineWidth',1.2)
hold on
plot((0:n-1)/100,p(:,2),'--','LineWidth',1.15)
grid on
legend('通道1','通道2')
