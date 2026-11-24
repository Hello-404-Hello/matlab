queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
target=index(king);
source=index(horse);
q=index(queen);
a=cell(64,1);
for i=1:64
    if i==q&&~can_take_queen, continue, end
    [r,c]=ind2sub([8,8],i);
    for j=1:64
        if j==q&&~can_take_queen, continue, end
        [x,y]=ind2sub([8,8],j);
        if abs(r-x)+abs(c-y)==3&&r~=x&&c~=y
            a{i}(end+1)=j;
        end
    end
end
known=zeros(64,1);
answer=walk(a,target,known,source,0);
disp(answer)

function i=index(p)
i=p(1)+8*(p(2)-1);
end

function n=walk(a,t,used,layer,level)
if any(layer==t)
    n=level;
elseif isempty(layer)
    n=-1;
else
    used(layer)=1;
    f=unique([a{layer}]);
    f(used(f)~=0)=[];
    n=walk(a,t,used,f,level+1);
end
end
