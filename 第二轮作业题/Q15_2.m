s=RandStream('mt19937ar','Seed',15);
a=randi(s,2,50,50)-1;
m={ones(1,5),ones(5,1),eye(5),fliplr(eye(5))};
dd=[0,1;1,0;1,1;1,-1];
figure('Color','w')
[row,col]=find(a);
plot(col,row,'.','Color',[.17,.27,.43])
hold on
axis ij equal
xlim([.5,50.5]); ylim([.5,50.5])
n=0;
for i=1:numel(m)
    [x,y]=find(conv2(a,m{i},'valid')==5);
    if i==4
        y=y+4;
    end
    n=n+numel(x);
    line([y,y+4*dd(i,2)]',[x,x+4*dd(i,1)]','Color',[.8,.12,.23])
end
disp(n)
