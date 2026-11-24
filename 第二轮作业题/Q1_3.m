a=7;
b=16;
while b<36
    if 5*b+2*a==126
        fprintf('%d %d\n',a,b)
    end
    a=a+1;
    if a==30
        a=7;
        b=b+1;
    end
end
