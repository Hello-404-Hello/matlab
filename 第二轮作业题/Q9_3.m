h=[305,298,290,265,246,225,207,189,165,148,130,114]/100;
t=2:23;
u=zeros(1,length(t));
for i=1:length(h)-1
    d=(h(i)-h(i+1))/2;
    u(2*i-1:2*i)=25*pi*d;
end
disp([t',t'+1,u'])
figure
bar(t+.5,u,.94)
xlabel('时刻（h）')
ylabel('每小时估算用水量（m³）')
xticks(2:2:24)
xlim([2,24])
title('区间内均匀分配')
