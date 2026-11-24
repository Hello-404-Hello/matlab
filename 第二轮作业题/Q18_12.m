queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
n=8;
board=false(n);
board(horse(1),horse(2))=true;
seen=board;
mask=true(n);
if ~can_take_queen, mask(queen(1),queen(2))=false; end
d=-1;
for depth=0:63
    if board(king(1),king(2))
        d=depth;
        break
    end
    b=false(n);
    for dr=[-2,-1,1,2]
        for dc=[-1,1]*(3-abs(dr))
            row=max(1,1-dr):min(n,n-dr);
            col=max(1,1-dc):min(n,n-dc);
            b(row+dr,col+dc)=b(row+dr,col+dc)|board(row,col);
        end
    end
    board=b&mask&~seen;
    if ~any(board,'all'), break, end
    seen=seen|board;
end
fprintf('%d\n',d)
