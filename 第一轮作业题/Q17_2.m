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
function value=hw17_penalty(xy,X,Y)
inside=min(10,max(0,xy));
value=hw17_cv(inside,X,Y)+sum((xy(:)-inside(:)).^2);
end
function hw17_plot(lamps,version)
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
