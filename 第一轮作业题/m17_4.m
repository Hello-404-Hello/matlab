[X,Y]=meshgrid(0:0.4:10);
value=inf;
ax=0;
ay=0;
for a=0:0.1:5
    for b=0:0.1:5
        points=[a,b;10-a,b;a,10-b;10-a,10-b];
        test=hw17_cv(points,X,Y);
        if test<value
            value=test;
            ax=a;
            ay=b;
        end
    end
end
xlist=max(0,ax-0.1):0.01:min(5,ax+0.1);
ylist=max(0,ay-0.1):0.01:min(5,ay+0.1);
for a=xlist
    for b=ylist
        points=[a,b;10-a,b;a,10-b;10-a,10-b];
        test=hw17_cv(points,X,Y);
        if test<value
            value=test;
            ax=a;
            ay=b;
        end
    end
end
lamps=[ax,ay,10;10-ax,ay,10;ax,10-ay,10;10-ax,10-ay,10];
initial=[0,0,10;10,0,10;0,10,10;10,10,10];
[X,Y]=meshgrid(0:0.1:10);
disp(lamps)
disp([hw17_cv(initial(:,1:2),X,Y),hw17_cv(lamps(:,1:2),X,Y)])
disp([ax,ay])
figure;
height=[0,3,6,9];
for k=1:4
    subplot(2,2,k)
    E=hw17_field(X,Y,height(k),initial);
    imagesc(0:0.1:10,0:0.1:10,E)
    title(num2str(height(k)))
    colorbar
end
figure;
E=hw17_field(X,Y,0,lamps);
imagesc(0:0.1:10,0:0.1:10,E)
colorbar
function value=hw17_cv(xy,X,Y)
lamps=[reshape(xy,4,2),10*ones(4,1)];
E=hw17_field(X,Y,0,lamps);
value=std(E(:),1)/mean(E(:));
end
function E=hw17_field(X,Y,Z,lamps)
E=zeros(size(X));
for k=1:size(lamps,1)
    distance2=(X-lamps(k,1)).^2+(Y-lamps(k,2)).^2+(Z-lamps(k,3)).^2;
    one=100./distance2;
    one(distance2==0)=NaN;
    E=E+one;
end
end
