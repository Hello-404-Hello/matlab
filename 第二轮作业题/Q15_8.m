rng(15)
b=randi([0,1],50);
pack=zeros(1,50,'uint64');
for r=1:50
    pack=bitor(pack,bitshift(uint64(b(r,:)),r-1));
end
d=[1,0;0,1;1,1;1,-1];
figure
imagesc(b)
axis image
colormap(gray)
hold on
count=0;
for j=1:4
    k=d(j,:);
    for c=1:50
        col=c+(0:4)*k(2);
        if any(col<1|col>50), continue, end
        hit=pack(col(1));
        for h=1:4
            hit=bitand(hit,bitshift(pack(col(h+1)),-h*k(1)));
        end
        for r=find(bitget(hit,1:50))
            line([c,col(end)],[r,r+4*k(1)],'Color','r')
            count=count+1;
        end
    end
end
fprintf('%d\n',count)
