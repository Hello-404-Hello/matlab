n=29;
[a,b]=decompose35_search(n);
disp([a b]);

function [a,b]=decompose35_search(n)
b=0;
while b<=floor(n/5)
    rest=n-5*b;
    if mod(rest,3)==0
        a=rest/3;
        return
    end
    b=b+1;
end
end
