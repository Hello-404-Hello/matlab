rng(15)
board=zeros(50);
for k=1:50
    board(:,k)=randi(2,50,1)-1;
end
d=[1,0;0,1;1,1;1,-1];
figure
[r,c]=find(board);
scatter(c,r,10,'filled')
axis ij equal
xlim([0,51]); ylim([0,51])
hold on
total=0;
for k=1:4
    [xy,n]=runs(board,d(k,:));
    total=total+n;
    u=xy(:,1)-4*d(k,1);
    v=xy(:,2)-4*d(k,2);
    line([v,xy(:,2)]',[u,xy(:,1)]','Color','r')
end
disp(total)

function [points,n]=runs(a,m)
s=zeros(52);
for i=1:50
    for j=1:50
        if a(i,j)
            s(i+1,j+1)=1+s(i+1-m(1),j+1-m(2));
        end
    end
end
[x,y]=find(s(2:51,2:51)>=5);
points=[x,y];
n=numel(x);
end
