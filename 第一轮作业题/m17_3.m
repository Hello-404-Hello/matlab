rng('shuffle');
[x,y]=meshgrid(linspace(0,10,31));
first=[0,0;10,0;0,10;10,10];
seeds=[first(:),5*ones(8,1),10*rand(8,2)];
winner=first(:);
lowest=hw17_cv(winner,x,y);
steps=[2,1,0.5,0.25,0.1,0.05];
for k=1:size(seeds,2)
    p=seeds(:,k);
    score=hw17_cv(p,x,y);
    for delta=steps
        for pass=1:20
            changed=false;
            for index=1:8
                for direction=[-1,1]
                    q=p;
                    q(index)=min(10,max(0,p(index)+direction*delta));
                    test=hw17_cv(q,x,y);
                    if test<score-1e-12
                        p=q;
                        score=test;
                        changed=true;
                    end
                end
            end
            if(~changed)
                break
            end
        end
    end
    if score<lowest
        winner=p;
        lowest=score;
    end
end
lamps=[reshape(winner,4,2),10*ones(4,1)];
[x,y]=meshgrid(linspace(0,10,101));
old=hw17_cv(first,x,y);
new=hw17_cv(winner,x,y);
if new>old
    lamps=[first,10*ones(4,1)];
    new=old;
end
disp(lamps)
disp([old,new])
hw17_plot(lamps,3);
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
