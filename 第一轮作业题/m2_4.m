clear
original=1000:-1:1;
left=zeros(1,1000);
count=0;
skip=0;
for k=1:1000
    if skip==0
        count=count+1;
        left(count)=original(k);
        skip=count;
    else
        skip=skip-1;
    end
end
left=left(1:count);
disp(left)
disp(count)
