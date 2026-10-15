% 四灯在z=10的房顶，单灯照度为100/r^2。
% 直接循环比较正方形布局的内缩量，目标是地面照度CV。
% 输出灯坐标与[初始CV,最佳CV]。
x=0:0.25:10;
y=x;
[xx,yy]=meshgrid(x,y);
initial=[0,0;10,0;0,10;10,10];
smallest=inf;
for a=0:0.1:5
    p=[a,a;10-a,a;a,10-a;10-a,10-a];
    e=zeros(size(xx));
    for j=1:4
        d2=(xx-p(j,1)).^2+(yy-p(j,2)).^2+100;
        e=e+100./d2;
    end
    cv=std(e(:),1)/mean(e(:));
    if a==0
        old=cv;
    end
    if cv<smallest
        smallest=cv;
        best=p;
    end
end
lamps=[best,10*ones(4,1)];
disp(lamps)
disp([old,smallest])
figure;
height=[0,3,6,9];
for k=1:4
    e=zeros(size(xx));
    for j=1:4
        e=e+100./((xx-initial(j,1)).^2+(yy-initial(j,2)).^2+(10-height(k))^2);
    end
    subplot(2,2,k);
    imagesc(x,y,e);
    title(num2str(height(k)));
    colorbar;
end
e=zeros(size(xx));
for j=1:4
    e=e+100./((xx-best(j,1)).^2+(yy-best(j,2)).^2+100);
end
figure;
pcolor(xx,yy,e);
shading flat;
colormap(hot);
colorbar;
axis equal tight;
