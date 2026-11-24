queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
kernel=[0,1,0,1,0;1,0,0,0,1;0,0,0,0,0;1,0,0,0,1;0,1,0,1,0];
p=false(8);
p(king(1),king(2))=true;
seen=p;
d=-1;
k=0;
while any(p,'all')
    if p(horse(1),horse(2)), d=k; break, end
    p=conv2(double(p),kernel,'same')>0&~seen;
    if ~can_take_queen, p(queen(1),queen(2))=false; end
    seen=seen|p;
    k=k+1;
end
disp(d)
