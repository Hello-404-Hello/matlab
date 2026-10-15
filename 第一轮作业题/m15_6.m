% 每个开放格子带一个编号，反复向四邻域传播较小编号。
% 同一连通块最终编号相同。输出是否顶到底连通，0或1。
rng('shuffle');
open=false(100);
open(randperm(10000,6500))=true;
label=reshape(1:10000,100,100);
label(~open)=inf;
while true
    next=label;
    next=min(next,[inf(1,100);label(1:99,:)]);
    next=min(next,[label(2:100,:);inf(1,100)]);
    next=min(next,[inf(100,1),label(:,1:99)]);
    next=min(next,[label(:,2:100),inf(100,1)]);
    next(~open)=inf;
    if isequal(next,label)
        break
    end
    label=next;
end
top=label(1,open(1,:));
bottom=label(100,open(100,:));
connected=~isempty(intersect(top,bottom));
disp(double(connected))
picture=zeros(100);
picture(open)=mod(label(open),31)+1;
figure;
imagesc(picture);
axis image;
colormap([0,0,0;lines(32)]);
