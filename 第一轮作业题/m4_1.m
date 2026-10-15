%%外接圆半径为1,每次绕接地点转动得到一段真实圆弧
clearvars
R=1;
travel=12;
sides=[3,4,5];
roughness=zeros(3,3);
figure;
hold on
for i=1:3
    n=sides(i);
    halfAngle=pi/n;
    b=R*sin(halfAngle);
    a=R*cos(halfAngle);
    X=[];
    Y=[];
    for step=0:ceil(travel/(2*b))-1
        angle=linspace(-halfAngle,halfAngle,301);
        X=[X,2*b*step+b+R*sin(angle)];
        Y=[Y,R*cos(angle)];
    end
    plot(X,Y,'LineWidth',1.3);
    %按水平路程平均计算起伏指标。
    meanHeight=R*(sin(halfAngle)*cos(halfAngle)+halfAngle)/(2*sin(halfAngle));
    meanSquare=R^2-b^2/3;
    roughness(i,:)=[n,R-a,sqrt(meanSquare-meanHeight^2)];
end
xlim([0,travel]);
ylim([0,1.1]);
grid on
xlabel('x');
ylabel('y');
legend('3','4','5','Location','southoutside');
%列:边数、高度极差、高度标准差。五边形最平稳,三角形最颠簸。
%正多边形在平地无滑动滚动。
disp(roughness)

