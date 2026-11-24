rng(15)
board=randi([0,1],50);
d=[1,0;0,1;1,1;-1,1];
n=0;
figure
[i,j]=find(board==0);
plot(j,i,'.','Color',[.72,.72,.72])
hold on
[i,j]=find(board);
plot(j,i,'k.')
for k=1:4
    dr=d(k,1); dc=d(k,2);
    for r=1:50
        for c=1:50
            if ~board(r,c)||stone(board,r-dr,c-dc)
                continue
            end
            a=r; b=c; count=1;
            while stone(board,a+dr,b+dc)
                a=a+dr; b=b+dc; count=count+1;
            end
            if count>=5
                plot([c,b],[r,a],'r.-','MarkerSize',11)
                n=n+count-4;
            end
        end
    end
end
axis ij equal
axis([1,50,1,50])
disp(n)

function p=stone(a,r,c)
p=r>=1&&r<=50&&c>=1&&c<=50&&a(r,c)==1;
end
