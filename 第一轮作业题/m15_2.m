rng('shuffle');
a=zeros(100,100);
pick=randperm(10000);
a(pick(1:6500))=1;
visited=false(100);
stack=zeros(10000,2);
p=0;
for j=1:100
    if a(1,j)==1
        p=p+1;
        stack(p,:)=[1,j];
        visited(1,j)=true;
    end
end
ok=0;
while p>0
    r=stack(p,1);
    c=stack(p,2);
    p=p-1;
    if r==100
        ok=1;
        break
    end
    nearby=[r,c-1;r-1,c;r,c+1;r+1,c];
    for q=1:4
        x=nearby(q,1);
        y=nearby(q,2);
        if x<1||x>100||y<1||y>100
            continue
        end
        if a(x,y)==1&&visited(x,y)==0
            visited(x,y)=true;
            p=p+1;
            stack(p,:)=[x,y];
        end
    end
end
disp(ok)
figure;
imagesc(a+visited);
axis equal tight;
colormap([0,0,0;1,1,1;0.2,0.7,1]);
