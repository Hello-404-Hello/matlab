z=readmatrix('Temp2.xlsx');
n=size(z,1);
p=movmean(z,7);
[~,peak]=max(p,[],1);
delay=peak(2)-peak(1);
disp([1+(delay<0);delay/100;5/abs(delay)])
figure
x=(0:n-1)/100;
plot(x,z)
hold on
plot(x(peak(1)),z(peak(1),1),'o')
plot(x(peak(2)),z(peak(2),2),'s')
legend('1','2','1 平滑峰位置','2 平滑峰位置')
xlabel('时间 / s')
