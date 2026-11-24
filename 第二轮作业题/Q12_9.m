a=readmatrix('Temp2.xlsx');
a0=(a-mean(a))./std(a);
k=-50:50;
loss=zeros(size(k));
for i=1:numel(k)
    h=k(i);
    j=max(1,1-h):min(length(a),length(a)-h);
    v=abs(a0(j,1)-a0(j+h,2));
    weights=min(.5,v);
    loss(i)=mean(.5*weights.^2+.5*max(0,v-.5));
end
[~,i]=min(loss);
h=k(i);
disp([1+(h<0),h/100,.05/(abs(h)/100)])
figure
plot((0:length(a)-1)/100,a,'LineWidth',1.2)
legend('1','2')
xlabel('时间（秒）')
title('Huber 损失对齐')
