a=267;
b=36;
[g,x,y]=findxy(abs(a),abs(b));
x=x*sign(a);
y=y*sign(b);
fprintf('%d·%d + %d·%d = %d\n',a,x,b,y,g)

function [g,x,y]=findxy(a,b)
if b==0
    g=a;
    x=1;
    y=0;
else
    r=mod(a,b);
    [g,u,v]=findxy(b,r);
    x=v;
    y=u-fix(a/b)*v;
end
end
