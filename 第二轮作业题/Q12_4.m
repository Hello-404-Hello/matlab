[a,b]=readvars('Temp2.xlsx');
d=[a,b];
n=size(d,1);
del=duiqi(d,50);
up=1+(del<0);
disp([up;abs(del)/100;.05/(abs(del)/100)])
figure
time=(1:n)/100-.01;
line(time,d(:,1),'Color',[.13,.53,.45])
line(time,d(:,2),'Color',[.82,.31,.22])
legend('1','2')
xlabel('时间 (s)')

function k=duiqi(x,m)
x=(x-mean(x))./std(x);
best=inf; k=0;
for j=-m:m
    i=max(1,1-j):min(size(x,1),size(x,1)-j);
    cost=mean((x(i,1)-x(i+j,2)).^2);
    if cost<best
        best=cost;
        k=j;
    end
end
end
