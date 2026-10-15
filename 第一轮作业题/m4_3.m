%%将每段圆弧写成高度关于水平位移的函数
clearvars;
x=linspace(0,12,12001);
numEdges=(3:5).';
heights=zeros(numel(x),3);
statistics=zeros(3,3);
for c=1:3
    n=numEdges(c);
    halfSide=sin(pi/n);
    phase=mod(x,2*halfSide)-halfSide;
    heights(:,c)=sqrt(1-phase.^2).';
    %只用一个完整周期,并在水平位置上等间距取样。
    offsets=linspace(-halfSide,halfSide,10001);
    samples=sqrt(1-offsets.^2);
    meanY=trapz(offsets,samples)/(2*halfSide);
    sd=sqrt(trapz(offsets,(samples-meanY).^2)/(2*halfSide));
    statistics(c,:)=[n,1-cos(pi/n),sd];
end
figure('Color','w');
plot(x,heights,'LineWidth',1.2);
axis([0,12,0,1.1]);
grid on;
legend('3','4','5');
xlabel('x');
ylabel('y');
%每行:边数、高度极差、高度标准差。数值越小,上下起伏越小。
%平地纯滚动的轮心轨迹由圆弧拼接,接点处会改变斜率。
disp(statistics);

