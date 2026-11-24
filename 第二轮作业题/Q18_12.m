enemy=[5,8;4,6];
start_rc=[5,4];
target_rc=enemy(1,:);
wall_rc=enemy(2,:);
eat_queen=logical(0);

n=8;
board=false(n);
board(start_rc(1),start_rc(2))=true;
seen=board;
mask=true(n);
if ~eat_queen, mask(wall_rc(1),wall_rc(2))=false; end
d=-1;
for depth=0:63
    if board(target_rc(1),target_rc(2))
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
