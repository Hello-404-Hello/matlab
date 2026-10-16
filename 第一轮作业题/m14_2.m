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
