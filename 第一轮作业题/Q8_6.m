n=29;
[three,five]=splitByLoops(n);
disp([three five]);

function [a,b]=splitByLoops(n)
for a=0:floor(n/3)
    for b=0:floor(n/5)
        if 3*a+5*b==n
            return
        end
    end
end
end
