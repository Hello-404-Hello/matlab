% 倒序枚举5的系数。
% 输入为大于8的整数，输出每组[3的系数,5的系数]。
n=29;
[c3,c5]=decompose35_descend(n);
disp([c3 c5]);

function [c3,c5]=decompose35_descend(n)
c5=floor(n/5);
while mod(n-5*c5,3)~=0
    c5=c5-1;
end
c3=(n-5*c5)/3;
end
