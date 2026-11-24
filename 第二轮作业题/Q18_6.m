args=[4;6;5;4];
p1=args(1:2).';
p2=args(3:4).';
rule=0;
finish_pos=[5,8];

dist=inf(64);
for a=1:64
    [x,y]=ind2sub([8,8],a);
    dist(a,a)=0;
    if ~rule&&isequal([x,y],p1), continue, end
    for b=a+1:64
        [i,j]=ind2sub([8,8],b);
        if ~rule&&isequal([i,j],p1), continue, end
        if abs((x-i)*(y-j))==2
            dist(a,b)=1;
            dist(b,a)=1;
        end
    end
end
for j=1:64
    dist=min(dist,dist(:,j)+dist(j,:));
end
u=sub2ind([8,8],p2(1),p2(2));
v=sub2ind([8,8],finish_pos(1),finish_pos(2));
n=dist(u,v);
if isinf(n), n=-1; end
disp(n)
