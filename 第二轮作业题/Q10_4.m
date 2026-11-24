eq=struct('a',267,'b',36);
a=eq.a;
b=eq.b;
d=gcd(a,b);
if b==0
    x=sign(a);
    y=0;
else
    for x=0:abs(b)/d-1
        z=d-a*x;
        if rem(z,b)==0
            break
        end
    end
    y=z/b;
end
disp([d;x;y])
