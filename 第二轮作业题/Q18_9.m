row=[4,5,5];
col=[6,4,8];
positions=[row;col].';
occupied=positions(1,:);
knight=positions(2,:);
goalpos=positions(3,:);
queen_is_free=false;

d=inf(12);
d(knight(1)+2,knight(2)+2)=0;
allowed=false(12);
allowed(3:10,3:10)=true;
if ~queen_is_free
    allowed(occupied(1)+2,occupied(2)+2)=false;
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
    if isfinite(d(goalpos(1)+2,goalpos(2)+2)), break, end
end
z=d(goalpos(1)+2,goalpos(2)+2);
if ~isfinite(z), z=-1; end
disp(z)
