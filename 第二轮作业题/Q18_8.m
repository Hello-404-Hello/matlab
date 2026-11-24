queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
jump=[2,1;1,2;-1,2;-2,1;-2,-1;-1,-2;1,-2;2,-1];
bound=0;
result=-1;
while bound<64
    left=-ones(8);
    if findgoal(horse,king,queen,jump,bound,can_take_queen)
        result=bound;
        break
    end
    bound=bound+1;
    if ~reachable(horse,king,queen,jump,can_take_queen,left), break, end
end
fprintf('%d\n',result)

function ok=findgoal(s,t,q,jump,k,take)
f=false(8);
f(s(1),s(2))=true;
for i=1:k
    f=move(f,q,jump,take);
end
ok=f(t(1),t(2));
end

function ok=reachable(s,t,q,jump,take,left)
f=left==0;
f(s(1),s(2))=true;
used=f;
while any(f,'all')
    if f(t(1),t(2)), ok=true; return, end
    f=move(f,q,jump,take)&~used;
    used=used|f;
end
ok=false;
end

function z=move(f,q,jump,take)
[x,y]=find(f);
z=false(8);
for j=1:8
    a=x+jump(j,1); b=y+jump(j,2);
    keep=a>=1&a<=8&b>=1&b<=8;
    if ~take, keep=keep&~(a==q(1)&b==q(2)); end
    z(sub2ind([8,8],a(keep),b(keep)))=true;
end
end
