xy=zeros(20,2);
n=0;
for b=35:-1:16
    a=(126-5*b)/2;
    if a>6&&a<30&&rem(a,1)==0
        n=n+1;
        xy(n,:)=[a,b];
    end
end
disp(table(xy(1:n,1),xy(1:n,2),'VariableNames',{'x','y'}))
