rng('shuffle');
trialCount=1200;
answer=zeros(trialCount,1);
for trial=1:trialCount
    gap=1000;
    n=0;
    while(~isempty(gap))
        space=gap-2;
        total=sum(space);
        if total==0
            n=n+numel(gap);
            break
        end
        chosen=find(cumsum(space)>rand*total,1);
        left=rand*space(chosen);
        right=space(chosen)-left;
        gap(chosen)=[];
        if left>=2
            gap(end+1)=left;
        end
        if right>=2
            gap(end+1)=right;
        end
        n=n+1;
    end
    answer(trial)=n;
end
average=mean(answer);
halfWidth=1.96*std(answer)/sqrt(trialCount);
disp(average)
disp([average-halfWidth,average+halfWidth])
