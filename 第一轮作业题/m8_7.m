% 按除以3的余数分三种情况。
% number为大于8的整数，输出[3的系数,5的系数]。
number=29;
[x,y]=splitByRemainder(number);
disp([x y]);

function [x,y]=splitByRemainder(number)
switch mod(number,3)
    case 0
        y=0;
        x=number/3;
    case 1
        y=2;
        x=(number-10)/3;
    case 2
        y=1;
        x=(number-5)/3;
end
end
