number=29;
[x,y]=decompose35_mod(number);
disp([x y]);

function [a,b]=decompose35_mod(n)
b=mod(2*mod(n,3),3);
a=(n-5*b)/3;
end
