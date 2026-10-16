rng('shuffle');
result=zeros(50,1);
for k=1:50
    map=false(100);
    map(randperm(10000,6500))=true;
    result(k)=walk(map);
    if k==1
        first=map;
    end
end
disp(result(1))
disp(mean(result))
figure;
imshow(first);

function yes=walk(map)
n=size(map,1);
queue=zeros(n*n,1);
seen=false(size(map));
last=0;
head=1;
for j=1:n
    if map(1,j)
        last=last+1;
        queue(last)=1+(j-1)*n;
        seen(1,j)=true;
    end
end
yes=0;
while head<=last
    now=queue(head);
    head=head+1;
    [r,c]=ind2sub([n,n],now);
    if r==n
        yes=1;
        break
    end
    neighbours=[r-1,c;r+1,c;r,c-1;r,c+1];
    for k=1:4
        rr=neighbours(k,1);
        cc=neighbours(k,2);
        if rr>=1&&rr<=n&&cc>=1&&cc<=n
            if map(rr,cc)&&~seen(rr,cc)
                seen(rr,cc)=true;
                last=last+1;
                queue(last)=rr+(cc-1)*n;
            end
        end
    end
end
end
