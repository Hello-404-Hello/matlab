pieces=struct('enemy',[5,8],'from',[5,4],'occupied',[4,6],'capture',false);
q0=pieces.occupied;
start_square=pieces.from;
goal_square=pieces.enemy;
allow=pieces.capture;

m=zeros(64);
moves=[1,2;2,1;2,-1;1,-2];
for x=1:8
    for y=1:8
        if ~allow&&isequal([x,y],q0), continue, end
        a=x+8*(y-1);
        for p=1:4
            z=[x,y]+moves(p,:);
            if all(z>=1&z<=8)&&(allow||~isequal(z,q0))
                b=z(1)+8*(z(2)-1);
                m(a,b)=1;
                m(b,a)=1;
            end
        end
    end
end
s=start_square(1)+8*(start_square(2)-1);
goal=goal_square(1)+8*(goal_square(2)-1);
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
