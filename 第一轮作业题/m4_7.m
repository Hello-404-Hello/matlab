%%用双层循环逐点求出三个轮心的高度
clear
x=0:0.002:12;
height=zeros(3,length(x));
roughness=zeros(3,3);
for i=1:3
    n=i+2;
    halfSide=sin(pi/n);
    period=2*halfSide;
    for j=1:length(x)
        segment=floor(x(j)/period);
        offset=x(j)-segment*period-halfSide;
        height(i,j)=sqrt(1-offset^2);
    end
    %在一个周期内等间距取中点,累加高度与高度平方。
    total=0;
    squareTotal=0;
    samples=20000;
    for j=1:samples
        offset=-halfSide+(j-0.5)*period/samples;
        z=sqrt(1-offset^2);
        total=total+z;
        squareTotal=squareTotal+z^2;
    end
    average=total/samples;
    roughness(i,:)=[n,1-cos(pi/n),sqrt(squareTotal/samples-average^2)];
end
figure
plot(x,height(1,:),'b',x,height(2,:),'r',x,height(3,:),'g')
legend('3','4','5')
%输出边数、高度极差、按水平路程平均的高度标准差。
disp(roughness)

