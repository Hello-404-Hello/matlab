h=[305,298,290,265,246,225,207,189,165,148,130,114]/100;
t=2:23;
u=zeros(1,length(t));
for i=1:length(h)-1
    d=(h(i)-h(i+1))/2;
    u(2*i-1:2*i)=25*pi*d;
end
disp([t',t'+1,u'])
figure
bar(3:2:23,reshape(u,2,[])','grouped')
xlabel('两小时区段的中点（h）')
ylabel('每小时估算用水量（m³）')
xticks(3:2:23)
xlim([2,24])
title('区间内均匀分配')
legend('区段前一小时','区段后一小时')
