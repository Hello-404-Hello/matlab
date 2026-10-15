% 双循环依次尝试3和5的系数。
% n为大于8的整数，输出[3的系数,5的系数]。
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
