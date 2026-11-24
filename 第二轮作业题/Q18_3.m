a=4; b=6;
c=5; d=4;
capture=false;
qpos=[a,b];
start=[c,d];
goal=[5,8];

fprintf('%d\n',both(start,goal,qpos,capture))

function n=both(a,b,q,take)
u=-ones(8); v=u;
u(a(1),a(2))=0; v(b(1),b(2))=0;
f=a; h=b;
n=-1;
while ~isempty(f)&&~isempty(h)
    if size(f,1)>size(h,1)
        [f,h]=deal(h,f);
        [u,v]=deal(v,u);
    end
    [f,u]=spread(f,u,q,take);
    across=u>=0&v>=0;
    if any(across,'all')
        n=min(u(across)+v(across));
        return
    end
end
end

function [out,d]=spread(f,d,q,take)
out=zeros(0,2);
jumps=[2,1;2,-1;-2,1;-2,-1;1,2;1,-2;-1,2;-1,-2];
for i=1:size(f,1)
    a=f(i,:);
    p=a+jumps;
    p(any(p<1|p>8,2),:)=[];
    if ~take, p(all(p==q,2),:)=[]; end
    for j=1:size(p,1)
        x=p(j,1); y=p(j,2);
        if d(x,y)<0
            d(x,y)=d(a(1),a(2))+1;
            out(end+1,:)=[x,y];
        end
    end
end
end
