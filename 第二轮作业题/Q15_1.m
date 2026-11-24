rng(15)
b=randi([0,1],50);
d=[0,1;1,0;1,1;1,-1];
r=[];
for i=1:50
    for j=1:50
        for k=1:4
            x=i+(0:4)*d(k,1); y=j+(0:4)*d(k,2);
            if y(end)>0&&y(end)<=50&&x(end)<=50
                if all(b(sub2ind([50,50],x,y))==1)
                    r(end+1,:)=[i,j,x(end),y(end)];
                end
            end
        end
    end
end
disp(size(r,1))
figure
imagesc(b)
axis image
colormap(gray)
hold on
for k=1:size(r,1)
    plot(r(k,[2,4]),r(k,[1,3]),'r-')
end
