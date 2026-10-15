% 广度优先搜索，随机选6500格开放。
% 输出1表示存在顶到底的通路，0表示不存在。图中红线是一条通路。
rng('shuffle');
n=100;
grid=false(n);
grid(randperm(n*n,6500))=true;
seen=false(n);
previous=zeros(n);
queue=zeros(n*n,1);
front=1;
back=0;
for col=1:n
    if grid(1,col)
        back=back+1;
        queue(back)=sub2ind([n,n],1,col);
        seen(1,col)=true;
    end
end
finish=0;
direction=[-1,0;1,0;0,-1;0,1];
while front<=back
    now=queue(front);
    front=front+1;
    [row,col]=ind2sub([n,n],now);
    if row==n
        finish=now;
        break
    end
    for d=1:4
        rr=row+direction(d,1);
        cc=col+direction(d,2);
        if rr>=1&&rr<=n&&cc>=1&&cc<=n&&grid(rr,cc)&&~seen(rr,cc)
            next=sub2ind([n,n],rr,cc);
            seen(next)=true;
            previous(next)=now;
            back=back+1;
            queue(back)=next;
        end
    end
end
disp(double(finish~=0))
figure;
imagesc(grid);
axis image;
colormap(gray);
hold on;
if finish~=0
    path=finish;
    while previous(path(end))~=0
        path(end+1)=previous(path(end));
    end
    [rr,cc]=ind2sub([n,n],path);
    plot(cc,rr,'r-','LineWidth',1.5);
end
hold off;
