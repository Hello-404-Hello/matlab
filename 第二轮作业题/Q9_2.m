level=[305,298,290,265,246,225,207,189,165,148,130,114];
radius=500;
n=length(level)-1;
water=zeros(n,1);
names=strings(n,1);
for k=1:n
    loss=level(k)-level(k+1);
    water(k)=pi*radius^2*loss/1e6;
    names(k)=sprintf('%02d–%02d',2*k,2*(k+1));
end
disp(table(names,water,'VariableNames',{'Hours','CubicMetres'}))
figure
barh(water)
set(gca,'YDir','reverse','YTick',1:n,'YTickLabel',names)
xlabel('用水量（m³）')
ylabel('时段')
grid on
