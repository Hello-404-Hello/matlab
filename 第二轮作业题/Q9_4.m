sample=2:2:24;
depth=[3.05,2.98,2.90,2.65,2.46,2.25,2.07,1.89,1.65,1.48,1.30,1.14];
hour=2:24;
[amount,fit]=usage(sample,depth,hour);
disp(table(hour(1:end-1)',hour(2:end)',amount','VariableNames',{'From','To','CubicMetres'}))
figure
tiledlayout(2,1)
nexttile
plot(hour,fit,'-',sample,depth,'o')
xlim([2,24])
ylabel('水位（m）')
legend('PCHIP 插值','实测点')
nexttile
bar(hour(1:end-1)+.5,amount)
xticks(2:2:24)
xlim([2,24])
xlabel('时刻（h）')
ylabel('小时用水量（m³）')

function [v,z]=usage(x,h,t)
z=ppval(pchip(x,h),t);
v=pi*(10/2)^2*(z(1:end-1)-z(2:end));
end
