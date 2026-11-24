queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
seen=false(8);
f=seen;
f(horse(1),horse(2))=true;
seen=f;
d=[1,2;2,1;-1,2;-2,1;1,-2;2,-1;-1,-2;-2,-1];
answ=-1;
for level=0:63
    if f(king(1),king(2))
        answ=level;
        break
    end
    if ~any(f,'all'), break, end
    z=false(12);
    for i=1:8
        x=(3:10)+d(i,1);
        y=(3:10)+d(i,2);
        z(x,y)=z(x,y)|f;
    end
    f=z(3:10,3:10)&~seen;
    if ~can_take_queen, f(queen(1),queen(2))=false; end
    seen=seen|f;
end
fprintf('%d\n',answ)
