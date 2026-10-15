% 单灯在1米处照度为100，灯位限制在z=10的房顶。
% 以地面(最大照度-最小照度)/平均照度为均匀度指标，多起点搜索。
% 输出灯坐标与[初始指标,优化指标]。
rng('shuffle');
initial=[0,0;10,0;0,10;10,10];
starts=[initial(:),10*rand(8,3)];
best=initial(:);
value=spreadObjective(best);
options=optimset('Display','off','MaxIter',1500,'MaxFunEvals',10000,...
    'TolX',1e-6,'TolFun',1e-10);
for k=1:4
    p=fminsearch(@spreadObjective,starts(:,k),options);
    p=min(10,max(0,p));
    score=spreadObjective(p);
    if score<value
        value=score;
        best=p;
    end
end
xy=reshape(best,4,2);
lamps=[xy,10*ones(4,1)];
[X,Y]=meshgrid(0:0.1:10);
old=lampField(X,Y,0,initial);
ground=lampField(X,Y,0,xy);
disp(lamps)
disp([(max(old(:))-min(old(:)))/mean(old(:)),(max(ground(:))-min(ground(:)))/mean(ground(:))])
figure;
z=[0,3,6,9];
for k=1:4
    subplot(2,2,k);
    E=lampField(X,Y,z(k),initial);
    imagesc([0,10],[0,10],E);
    axis xy image;
    colorbar;
    title(num2str(z(k)));
end
figure;
imagesc([0,10],[0,10],ground);
axis xy image;
colormap(turbo);
colorbar;

function result=spreadObjective(p)
q=min(10,max(0,p));
xy=reshape(q,4,2);
[X,Y]=meshgrid(0:0.4:10);
E=lampField(X,Y,0,xy);
result=(max(E(:))-min(E(:)))/mean(E(:))+sum((p(:)-q(:)).^2);
end

function E=lampField(X,Y,z,xy)
E=zeros(size(X));
for j=1:4
    E=E+100./((X-xy(j,1)).^2+(Y-xy(j,2)).^2+(10-z)^2);
end
end
