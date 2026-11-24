keyboard_input=false;
coords=[4,6,5,4];
if keyboard_input
    coords=input('请输入皇后和马的四个坐标 [a b c d]：');
end
blocked_square=coords(1:2);
knight_start=coords(3:4);
target_square=[5,8];
take_it=false;

g=inf(8);
g(knight_start(1),knight_start(2))=0;
done=false(8);
if ~take_it, done(blocked_square(1),blocked_square(2))=true; end
[x,y]=ndgrid(1:8);
h=max(ceil(max(abs(x-target_square(1)),abs(y-target_square(2)))/2),ceil((abs(x-target_square(1))+abs(y-target_square(2)))/3));
for k=1:64
    f=g+h;
    f(done)=inf;
    [z,i]=min(f,[],'all','linear');
    if isinf(z), break, end
    [a,b]=ind2sub([8,8],i);
    if a==target_square(1)&&b==target_square(2), break, end
    done(a,b)=true;
    next=abs((x-a).*(y-b))==2&~done;
    g(next)=min(g(next),g(a,b)+1);
end
us=g(target_square(1),target_square(2));
if isinf(us), us=-1; end
disp(us)
