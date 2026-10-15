%%使用旋转矩阵计算轮心绕前方顶点的运动
clear
answer=zeros(3,3);
figure
hold on
for n=3:5
    h=pi/n;
    b=sin(h);
    a=cos(h);
    theta=linspace(0,2*h,1001);
    oneX=zeros(size(theta));
    oneY=zeros(size(theta));
    for j=1:numel(theta)
        t=theta(j);
        rotate=[cos(t),sin(t);-sin(t),cos(t)];
        p=rotate*[-b;a]+[b;0];
        oneX(j)=p(1);
        oneY(j)=p(2);
    end
    allX=[];
    allY=[];
    for k=0:ceil(12/(2*b))-1
        allX=[allX,oneX+2*b*k];
        allY=[allY,oneY];
    end
    plot(allX,allY);
    average=trapz(oneX,oneY)/(2*b);
    sigma=sqrt(trapz(oneX,(oneY-average).^2)/(2*b));
    answer(n-2,:)=[n,max(oneY)-min(oneY),sigma];
end
axis([0,12,0,1.1])
grid on
legend('3','4','5')
xlabel('x')
ylabel('y')
%依次输出边数、轮心高度极差、按水平路程加权的高度标准差。
%三角形的两项指标最大,五边形最小。
disp(answer)

