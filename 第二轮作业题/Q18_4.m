queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
[x,y]=ndgrid(1:8);
a=[x(:),y(:)];
u=abs(a(:,1)-a(:,1)');
v=abs(a(:,2)-a(:,2)');
mask=(u==1&v==2)|(u==2&v==1);
if ~can_take_queen
    q=sub2ind([8,8],queen(1),queen(2));
    mask(q,:)=false; mask(:,q)=false;
end
g=graph(mask);
s=sub2ind([8,8],horse(1),horse(2));
t=sub2ind([8,8],king(1),king(2));
p=shortestpath(g,s,t,'Method','unweighted');
disp(length(p)-1)
