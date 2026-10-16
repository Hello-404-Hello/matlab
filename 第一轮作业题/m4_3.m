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
disp(statistics);
