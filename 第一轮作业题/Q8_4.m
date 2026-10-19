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
