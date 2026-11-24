rng(15)
s=randi([0,1],50);
vertical=zeros(1,50);
right=vertical;
left=vertical;
seg=[];
for i=1:50
    prev=[0,right(1:end-1)];
    after=[left(2:end),0];
    v=s(i,:)==1;
    vertical=(vertical+1).*v;
    right=(prev+1).*v;
    left=(after+1).*v;
    c=find(vertical>=5);
    seg=[seg;[c',c',repmat([i-4,i],numel(c),1)]];
    c=find(right>=5);
    seg=[seg;[c'-4,c',repmat([i-4,i],numel(c),1)]];
    c=find(left>=5);
    seg=[seg;[c'+4,c',repmat([i-4,i],numel(c),1)]];
    n=0;
    for j=1:50
        n=(n+1)*v(j);
        if n>=5
            seg(end+1,:)=[j-4,j,i,i];
        end
    end
end
disp(size(seg,1))
figure('Color','w')
[a,b]=find(s);
plot(b,a,'k.')
hold on
line(seg(:,1:2)',seg(:,3:4)','Color','r')
axis([.5,50.5,.5,50.5])
axis ij square
