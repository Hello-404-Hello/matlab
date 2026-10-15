%%用逻辑标记记录要保留的位置
clearvars
x=1000:-1:1;
keep=false(size(x));
i=1;
step=2;
while i<=length(x)
    keep(i)=true;
    i=i+step;
    step=step+1;
end
answer=x(keep);
disp(answer)
disp(sum(keep))

