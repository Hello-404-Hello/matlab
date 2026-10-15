% 灯在10米高房顶，照度按100/r^2叠加。
% 两重循环枚举对称矩形的横、纵内缩量，比较地面CV。
% 输出灯坐标与[初始CV,最佳CV]。
[x,y]=meshgrid(0:0.25:10);
c=[0,0;10,0;0,10;10,10];
value=inf;
for a=0:0.25:5
    for b=0:0.25:5
        p=[a,b;10-a,b;a,10-b;10-a,10-b];
        light=zeros(size(x));
        for k=1:4
            light=light+100./((x-p(k,1)).^2+(y-p(k,2)).^2+100);
        end
        score=std(light(:),1)/mean(light(:));
        if a==0&&b==0
            first=score;
        end
        if score<value
            value=score;
            answer=p;
        end
    end
end
lamps=[answer,10*ones(4,1)];
disp(lamps)
disp([first,value])
figure;
z=[0,3,6,9];
for i=1:4
    light=zeros(size(x));
    for k=1:4
        light=light+100./((x-c(k,1)).^2+(y-c(k,2)).^2+(10-z(i))^2);
    end
    subplot(2,2,i);
    contourf(x,y,light,12);
    colorbar;
    title(num2str(z(i)));
end
light=zeros(size(x));
for k=1:4
    light=light+100./((x-answer(k,1)).^2+(y-answer(k,2)).^2+100);
end
figure;
surf(x,y,light,'EdgeColor','none');
view(2);
colormap(cool);
axis equal tight;
colorbar;
