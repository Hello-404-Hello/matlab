%%用复数旋转表示轮心绕接地点运动
clearvars
result=zeros(3,3);
figure
hold on
for n=3:5
    halfAngle=pi/n;
    halfSide=sin(halfAngle);
    turn=linspace(0,2*halfAngle,1001);
    %实部表示横坐标,虚部表示高度;每次绕前方顶点顺时针旋转。
    oneArc=halfSide+exp(1i*(pi/2+halfAngle-turn));
    trace=[];
    for k=0:ceil(12/(2*halfSide))-1
        trace=[trace,oneArc+2*halfSide*k];
    end
    plot(real(trace),imag(trace))
    xx=real(oneArc);
    yy=imag(oneArc);
    meanY=trapz(xx,yy)/(2*halfSide);
    sd=sqrt(trapz(xx,(yy-meanY).^2)/(2*halfSide));
    result(n-2,:)=[n,max(yy)-min(yy),sd];
end
legend('3','4','5')
%每行输出边数、高度极差、按水平路程加权的高度标准差。
%两项起伏指标均为三角形最大、五边形最小。
disp(result)

