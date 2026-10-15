%%将轮心轨迹写成局部函数,主程序负责画图
clearvars;
distance=linspace(0,12,8001);
colors=[0.2,0.45,0.75;0.85,0.35,0.2;0.25,0.65,0.35];
statistics=zeros(3,3);
figure;
hold on;
for edge=3:5
    [height,metrics]=wheel_height(distance,edge);
    plot(distance,height,'Color',colors(edge-2,:),'LineWidth',1.5);
    statistics(edge-2,:)=[edge,metrics];
end
legend('3','4','5');
grid on;
xlabel('x');
ylabel('y');
%每行:边数、高度极差、按水平路程平均的高度标准差。
disp(statistics);

function [y,metrics]=wheel_height(x,n)
h=pi/n;
b=sin(h);
y=sqrt(1-(mod(x,2*b)-b).^2);
average=(b*cos(h)+h)/(2*b);
metrics=[1-cos(h),sqrt(1-b^2/3-average^2)];
end

