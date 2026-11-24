queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
m=zeros(64);
moves=[1,2;2,1;2,-1;1,-2];
for x=1:8
    for y=1:8
        if ~can_take_queen&&isequal([x,y],queen), continue, end
        a=x+8*(y-1);
        for p=1:4
            z=[x,y]+moves(p,:);
            if all(z>=1&z<=8)&&(can_take_queen||~isequal(z,queen))
                b=z(1)+8*(z(2)-1);
                m(a,b)=1;
                m(b,a)=1;
            end
        end
    end
end
s=horse(1)+8*(horse(2)-1);
goal=king(1)+8*(king(2)-1);
seen=false(1,64);
seen(s)=true;
here=seen;
answ=-1;
for j=0:63
    if here(goal)
        answ=j;
        break
    end
    here=(double(here)*m>0)&~seen;
    if ~any(here), break, end
    seen=seen|here;
end
disp(answ)
