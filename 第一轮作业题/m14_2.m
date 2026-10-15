% 先把第一个帐篷随机放入，再分别填满左右两段。
% 两个子区间互不影响，所以用栈依次处理与随机到达的最终数量同分布。
% 这里以2米为一个单位，原场地长500个单位。
% 输出：平均数；[最小数,最大数,样本标准差]。
rng('shuffle');
times=1500;
counts=zeros(times,1);
for k=1:times
    todo=zeros(1001,1);
    top=1;
    todo(top)=500;
    count=0;
    while top>0
        len=todo(top);
        top=top-1;
        if len<1
            continue
        end
        count=count+1;
        free=len-1;
        first=rand*free;
        second=free-first;
        if first>=1
            top=top+1;
            todo(top)=first;
        end
        if second>=1
            top=top+1;
            todo(top)=second;
        end
    end
    counts(k)=count;
end
disp(sum(counts)/times)
disp([min(counts),max(counts),std(counts)])
