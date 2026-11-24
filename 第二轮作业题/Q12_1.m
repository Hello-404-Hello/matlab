x=readmatrix('Temp2.xlsx');
t=(0:size(x,1)-1)'/100;
a=x(:,1)-mean(x(:,1));
b=x(:,2)-mean(x(:,2));
[c,k]=xcorr(b,a,50,'coeff');
[~,i]=max(c);
lag=k(i);
up=1+(lag<0);
v=5/abs(lag);
disp([up,lag,v])
figure
plot(t,x)
legend('1','2')
xlabel('s'); ylabel('温度')
