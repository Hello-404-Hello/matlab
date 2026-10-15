% 建模：每盏灯距离1米时照度为100勒克斯，照度按100/r^2叠加。
% 灯装在天花板z=10，0<=x,y<=10。
% 用地面照度变异系数CV衡量均匀度，越小越好。
% 思路一：四灯关于房间中心对称，把8个变量降为正方形的1个内缩量。
% 比较对称布局的内缩量及两个端点。
% 输出4行灯坐标，随后输出[初始CV,优化CV]。
[X,Y]=meshgrid(linspace(0,10,61));
layout=@(a)[a,a;10-a,a;a,10-a;10-a,10-a];
objective=@(a)hw17_cv(layout(a),X,Y);
a=fminbnd(objective,0,5,optimset('TolX',1e-7,'Display','off'));
candidates=[0,a,5];
scores=arrayfun(objective,candidates);
[~,which]=min(scores);
a=candidates(which);
lamps=[layout(a),10*ones(4,1)];
disp(lamps)
disp([objective(0),objective(a)])
hw17_plot(lamps,1);
function value=hw17_cv(xy,X,Y)
% 地面均匀度目标：总体标准差/平均照度，越小越均匀。
lamps=[reshape(xy,4,2),10*ones(4,1)];
E=hw17_field(X,Y,0,lamps);
value=std(E(:),1)/mean(E(:));
end
function E=hw17_field(X,Y,Z,lamps)
% 100表示距离单灯1米处的照度标定；按题意仅采用逆平方关系。
E=zeros(size(X));
for k=1:size(lamps,1)
    distance2=(X-lamps(k,1)).^2+(Y-lamps(k,2)).^2+(Z-lamps(k,3)).^2;
    one=100./distance2;
    one(distance2==0)=NaN;
    E=E+one;
end
end
function hw17_plot(lamps,version)
% 四个水平切片覆盖房间内部的不同高度；另外绘制优化后的地面伪彩色图。
original=[0,0,10;10,0,10;0,10,10;10,10,10];
[X,Y]=meshgrid(linspace(0,10,101));
z=[0,3,6,9];
figure;
for k=1:4
    subplot(2,2,k);
    field=hw17_field(X,Y,z(k),original);
    imagesc([0,10],[0,10],field);
    axis xy equal tight;
    colorbar;
    title(sprintf('z=%.0f m',z(k)));
    xlabel('x / m');
    ylabel('y / m');
end
figure;
ground=hw17_field(X,Y,0,lamps);
if version==1
    imagesc([0,10],[0,10],ground);
    axis xy equal tight;
elseif version==2
    surf(X,Y,ground,'EdgeColor','none');
    view(2);
    axis equal tight;
else
    pcolor(X,Y,ground);
    shading interp;
    axis equal tight;
end
colorbar;
xlabel('x / m');
ylabel('y / m');
title('Floor illuminance / lx');
end
