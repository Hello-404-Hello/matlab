queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
g=inf(8);
g(horse(1),horse(2))=0;
done=false(8);
if ~can_take_queen, done(queen(1),queen(2))=true; end
[x,y]=ndgrid(1:8);
h=max(ceil(max(abs(x-king(1)),abs(y-king(2)))/2),ceil((abs(x-king(1))+abs(y-king(2)))/3));
for k=1:64
    f=g+h;
    f(done)=inf;
    [z,i]=min(f,[],'all','linear');
    if isinf(z), break, end
    [a,b]=ind2sub([8,8],i);
    if a==king(1)&&b==king(2), break, end
    done(a,b)=true;
    next=abs((x-a).*(y-b))==2&~done;
    g(next)=min(g(next),g(a,b)+1);
end
us=g(king(1),king(2));
if isinf(us), us=-1; end
disp(us)
