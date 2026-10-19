rng('shuffle');
a=zeros(100);
a(randperm(10000,6500))=1;
visited=false(100);
list=[ones(nnz(a(1,:)),1),find(a(1,:))'];
ok=0;
while(~isempty(list))
    r=list(end,1);
    c=list(end,2);
    list(end,:)=[];
    if visited(r,c)
        continue
    end
    l=c;
    h=c;
    while l>1&&a(r,l-1)==1&&~visited(r,l-1)
        l=l-1;
    end
    while h<100&&a(r,h+1)==1&&~visited(r,h+1)
        h=h+1;
    end
    visited(r,l:h)=true;
    if r==100
        ok=1;
        break
    end
    for j=l:h
        if r>1&&a(r-1,j)==1&&~visited(r-1,j)
            list(end+1,:)=[r-1,j];
        end
        if r<100&&a(r+1,j)==1&&~visited(r+1,j)
            list(end+1,:)=[r+1,j];
        end
    end
end
disp(ok)
figure;
imagesc(a+visited);
