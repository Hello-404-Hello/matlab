record='4,6,5,4';
p=sscanf(strrep(record,',',' '),'%d').';
block=p(1:2);
start_pos=p(3:4);
end_pos=[5,8];
ignore_block=false;

[x,y]=ndgrid(1:8);
a=[x(:),y(:)];
u=abs(a(:,1)-a(:,1)');
v=abs(a(:,2)-a(:,2)');
mask=(u==1&v==2)|(u==2&v==1);
if ~ignore_block
    q=sub2ind([8,8],block(1),block(2));
    mask(q,:)=false; mask(:,q)=false;
end
g=graph(mask);
s=sub2ind([8,8],start_pos(1),start_pos(2));
t=sub2ind([8,8],end_pos(1),end_pos(2));
p=shortestpath(g,s,t,'Method','unweighted');
disp(length(p)-1)
