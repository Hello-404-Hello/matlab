a=readmatrix('Temp2.xlsx');
b=diff(movmean(a,5));
n=size(b,1);
best=-inf;
delay=0;
for k=-50:50
    j=max(1,1-k):min(n,n-k);
    x=b(j,1);
    y=b(j+k,2);
    score=dot(x,y)/(norm(x)*norm(y));
    if score>best
        best=score;
        delay=k;
    end
end
disp([1+(delay<0),delay*.01,5/abs(delay)])
figure
t=(0:size(a,1)-1)/100;
plot(t,a(:,1),t,a(:,2),'-.')
xlabel('时间 / s')
legend('传感器 1','传感器 2')
