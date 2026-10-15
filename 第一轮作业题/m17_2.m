% 单灯在1米距离的照度为100，按逆平方关系叠加。
% 固定安装在z=10的天花板内，以地面照度的标准差/均值为目标。
% 思路二：8个平面坐标全部可变，多起点fminsearch加越界惩罚。
% 输出4行灯坐标，随后输出[初始CV,优化CV]（在更密网格复核）。
rng('shuffle');
[xx,yy]=meshgrid(0:0.4:10);
corners=[0,0;10,0;0,10;10,10];
inset=[2,2;8,2;2,8;8,8];
starts=[corners(:),inset(:),10*rand(8,2)];
best=corners(:);
bestValue=hw17_cv(best,xx,yy);
options=optimset('Display','off','MaxIter',1800,'MaxFunEvals',12000,...
    'TolX',1e-6,'TolFun',1e-10);
for t=1:size(starts,2)
    solution=fminsearch(@(v)hw17_penalty(v,xx,yy),starts(:,t),options);
    solution=min(10,max(0,solution));
    value=hw17_cv(solution,xx,yy);
    if value<bestValue
        best=solution;
        bestValue=value;
    end
end
lamps=[reshape(best,4,2),10*ones(4,1)];
[checkX,checkY]=meshgrid(linspace(0,10,101));
oldValue=hw17_cv(corners,checkX,checkY);
newValue=hw17_cv(best,checkX,checkY);
if newValue>oldValue
    lamps=[corners,10*ones(4,1)];
    newValue=oldValue;
end
disp(lamps)
disp([oldValue,newValue])
hw17_plot(lamps,2);
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
function value=hw17_penalty(xy,X,Y)
% 将越界量加入目标函数，配合fminsearch求解。
inside=min(10,max(0,xy));
value=hw17_cv(inside,X,Y)+sum((xy(:)-inside(:)).^2);
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
