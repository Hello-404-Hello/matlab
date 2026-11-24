rng(15,'twister')
seq=randi([0,1],2500,1);
b=reshape(seq,50,50);
e=[1,0;0,1;1,1;1,-1];
mark=false(50);
n=0;
lines=[];
[i,j]=find(b);
for d=1:4
    for k=1:numel(i)
        x=i(k)+(0:4)*e(d,1); y=j(k)+(0:4)*e(d,2);
        if min(y)<1||max(y)>50||max(x)>50, continue, end
        at=sub2ind(size(b),x,y);
        if prod(b(at))==1
            mark(at)=true;
            n=n+1;
            lines(n,:)=[x(1),y(1),x(5),y(5)];
        end
    end
end
figure
imagesc(b+mark)
colormap([.94,.94,.93;.23,.26,.28;.82,.31,.28])
axis image
hold on
line(lines(:,[2,4])',lines(:,[1,3])','Color',[.8,.06,.12])
fprintf('%d / %d\n',n,nnz(mark))
