setup=[4,6;5,4;5,8];
[huanghou,ma,wang]=deal(setup(1,:),setup(2,:),setup(3,:));
allow_capture=false;

seen=false(8);
f=seen;
f(ma(1),ma(2))=true;
seen=f;
d=[1,2;2,1;-1,2;-2,1;1,-2;2,-1;-1,-2;-2,-1];
answ=-1;
for level=0:63
    if f(wang(1),wang(2))
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
    if ~allow_capture, f(huanghou(1),huanghou(2))=false; end
    seen=seen|f;
end
fprintf('%d\n',answ)
