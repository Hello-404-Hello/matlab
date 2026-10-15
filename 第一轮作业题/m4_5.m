%%用不同黑色线型比较三个车轮的起伏
clear
x=0:0.002:12;
styles={'k-','k--','k:'};
answer=zeros(3,3);
figure
hold on
for i=1:3
    n=i+2;
    angle=pi/n;
    b=sin(angle);
    a=cos(angle);
    localX=mod(x,2*b)-b;
    y=sqrt(1-localX.^2);
    plot(x,y,styles{i});
    average=(b*a+angle)/(2*b);
    deviation=sqrt(1-b^2/3-average^2);
    answer(i,:)=[n,1-a,deviation];
end
legend('3','4','5')
%三列分别为边数、最高最低差、按水平路程平均的高度标准差。
%五边形两项指标最小,三角形最大。
disp(answer)
