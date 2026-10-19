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
