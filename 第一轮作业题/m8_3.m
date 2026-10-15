% 从9、10、11三个基例扩展。
% 输入为大于8的整数，输出每组[3的系数,5的系数]。
N=29;
[three,five]=decompose35_base(N);
disp([three five]);

function [a,b]=decompose35_base(n)
basic=[3 0;0 2;2 1];
r=mod(n-9,3);
extra=(n-9-r)/3;
a=basic(r+1,1)+extra;
b=basic(r+1,2);
end
