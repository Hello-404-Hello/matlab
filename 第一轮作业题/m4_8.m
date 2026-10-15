%%旋转矩阵封装在文件末尾,主程序采用不同线型
clearvars
styles={'-.','--','-'};
result=zeros(3,3);
figure
hold on
for n=3:5
    [x,y,spread]=rolling_wheel(n,12);
    plot(x,y,styles{n-2},'LineWidth',1.4);
    result(n-2,:)=[n,spread];
end
legend('3','4','5')
axis([0,12,0.45,1.05])
grid on
%三列:边数、高度极差、按水平路程平均的高度标准差。
disp(result)

function [x,y,spread]=rolling_wheel(n,distance)
angle=pi/n;
b=sin(angle);
a=cos(angle);
theta=linspace(0,2*angle,1001);
arc=zeros(2,numel(theta));
for k=1:numel(theta)
    t=theta(k);
    rotation=[cos(t),sin(t);-sin(t),cos(t)];
    arc(:,k)=[b;0]+rotation*[-b;a];
end
x=[];
y=[];
for step=0:ceil(distance/(2*b))-1
    x=[x,arc(1,:)+step*2*b];
    y=[y,arc(2,:)];
end
average=trapz(arc(1,:),arc(2,:))/(2*b);
variance=trapz(arc(1,:),(arc(2,:)-average).^2)/(2*b);
spread=[1-a,sqrt(variance)];
end

