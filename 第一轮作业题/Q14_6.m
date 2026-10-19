rng('shuffle');
n=zeros(1,900);
for i=1:900
    n(i)=putTent(1000);
end
disp(mean(n))
figure;
histogram(n);

function count=putTent(length)
if length<2
    count=0;
else
    left=rand*(length-2);
    right=length-2-left;
    count=1+putTent(left)+putTent(right);
end
end
