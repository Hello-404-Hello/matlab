% 先在整个岸边随机试放，冲突就重试，属于拒绝采样思路。
% 连续50次失败后直接在当前可放区间中均匀取一点，提高后期效率。
% 两种取样方式的成功落点分布相同；停止条件始终是没有2米空档。
% 输出平均数量，再输出平均数的近似95%置信区间。
rng('shuffle');
times=400;
numbers=zeros(times,1);
for t=1:times
    placed=[];
    while true
        placed=sort(placed);
        gapLeft=[0,placed+2];
        gapRight=[placed,1000];
        gapLength=gapRight-gapLeft;
        usable=gapLength>=2;
        if(~any(usable))
            break
        end
        spot=998*rand;
        failures=0;
        while any(spot<placed+2&spot+2>placed)
            failures=failures+1;
            if failures==50
                left=gapLeft(usable);
                width=gapLength(usable)-2;
                total=sum(width);
                if total==0
                    spot=left(1);
                else
                    k=find(cumsum(width)>rand*total,1);
                    spot=left(k)+rand*width(k);
                end
                break
            end
            spot=998*rand;
        end
        placed(end+1)=spot;
    end
    numbers(t)=numel(placed);
end
m=mean(numbers);
err=1.96*std(numbers)/sqrt(times);
disp(m)
disp([m-err,m+err])
