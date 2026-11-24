queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
dist=inf(64);
for a=1:64
    [x,y]=ind2sub([8,8],a);
    dist(a,a)=0;
    if ~can_take_queen&&isequal([x,y],queen), continue, end
    for b=a+1:64
        [i,j]=ind2sub([8,8],b);
        if ~can_take_queen&&isequal([i,j],queen), continue, end
        if abs((x-i)*(y-j))==2
            dist(a,b)=1;
            dist(b,a)=1;
        end
    end
end
for j=1:64
    dist=min(dist,dist(:,j)+dist(j,:));
end
u=sub2ind([8,8],horse(1),horse(2));
v=sub2ind([8,8],king(1),king(2));
n=dist(u,v);
if isinf(n), n=-1; end
disp(n)
