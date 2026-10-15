% 房顶高度10，四灯照度100/r^2相加，用CV比较地面均匀度。
% 将坐标轮换搜索和照度计算展开到主程序，逐步减小移动步长。
% 输出灯坐标与[初始CV,最佳CV]。
rng('shuffle');
[X,Y]=meshgrid(0:0.4:10);
corner=[0,0;10,0;0,10;10,10];
inside=[2,2;8,2;2,8;8,8];
starts=[corner(:),inside(:),10*rand(8,1)];
E=zeros(size(X));
for lamp=1:4
    E=E+100./((X-corner(lamp,1)).^2+(Y-corner(lamp,2)).^2+100);
end
old=std(E(:),1)/mean(E(:));
bestScore=old;
best=corner(:);
for trial=1:3
    p=starts(:,trial);
    xy=reshape(p,4,2);
    E=zeros(size(X));
    for lamp=1:4
        E=E+100./((X-xy(lamp,1)).^2+(Y-xy(lamp,2)).^2+100);
    end
    score=std(E(:),1)/mean(E(:));
    for step=[2,1,0.5,0.25,0.1]
        for turn=1:12
            changed=0;
            for i=1:8
                for direction=[-1,1]
                    q=p;
                    q(i)=min(10,max(0,p(i)+direction*step));
                    xy=reshape(q,4,2);
                    E=zeros(size(X));
                    for lamp=1:4
                        E=E+100./((X-xy(lamp,1)).^2+(Y-xy(lamp,2)).^2+100);
                    end
                    test=std(E(:),1)/mean(E(:));
                    if test<score-1e-12
                        p=q;
                        score=test;
                        changed=1;
                    end
                end
            end
            if changed==0
                break
            end
        end
    end
    if score<bestScore
        bestScore=score;
        best=p;
    end
end
xy=reshape(best,4,2);
lamps=[xy,10*ones(4,1)];
disp(lamps)
disp([old,bestScore])
figure;
z=[0,3,6,9];
for k=1:4
    E=zeros(size(X));
    for j=1:4
        E=E+100./((X-corner(j,1)).^2+(Y-corner(j,2)).^2+(10-z(k))^2);
    end
    subplot(2,2,k);
    mesh(X,Y,E);
    title(num2str(z(k)));
end
E=zeros(size(X));
for j=1:4
    E=E+100./((X-xy(j,1)).^2+(Y-xy(j,2)).^2+100);
end
figure;
imagesc([0,10],[0,10],E);
colorbar;
