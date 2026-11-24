[x,y]=ndgrid(7:29,16:35);
out=cell(20,1);
k=0;
for i=1:numel(x)
    if x(i)*2+y(i)*5==126
        k=k+1;
        out{k}=[x(i),y(i)];
    end
end
disp(vertcat(out{1:k}))
