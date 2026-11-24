x=.6; y=-.9;
for i=1:30
    a=x+y*y+2*y;
    g=[2*a+1;2*y+2];
    b=[4*a+4,4*y+4;4*y+4,2];
    step=b\g;
    x=x-step(1); y=y-step(2);
    if norm(step)<1e-10
        break
    end
end
z=exp(2*x)*(x+y*y+2*y);
fprintf('%.9f %.9f %.9f\n',x,y,z)
