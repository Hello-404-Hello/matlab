queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
d=inf(12);
d(horse(1)+2,horse(2)+2)=0;
allowed=false(12);
allowed(3:10,3:10)=true;
if ~can_take_queen
    allowed(queen(1)+2,queen(2)+2)=false;
end
next=d;
for k=1:63
    for y=3:10
        for x=3:10
            if allowed(x,y)
                a=d(x-2,[y-1,y+1]);
                b=d(x+2,[y-1,y+1]);
                c=d(x-1,[y-2,y+2]);
                e=d(x+1,[y-2,y+2]);
                next(x,y)=min(d(x,y),1+min([a,b,c,e]));
            end
        end
    end
    if isequal(d,next), break, end
    d=next;
    if isfinite(d(king(1)+2,king(2)+2)), break, end
end
z=d(king(1)+2,king(2)+2);
if ~isfinite(z), z=-1; end
disp(z)
