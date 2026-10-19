rng('shuffle');
requests=zeros(150,4);
for id=1:150
    stations=sort(randperm(16,2));
    requests(id,:)=[id,rand,stations];
end
requests=sortrows(requests,[2,1]);
booked=cell(100,1);
result=zeros(150,6);
for k=1:150
    a=requests(k,3);
    b=requests(k,4);
    score=inf(100,1);
    for s=1:100
        old=booked{s};
        if isempty(old)
            score(s)=16-1;
            continue
        end
        if any(old(:,1)<b&old(:,2)>a)
            continue
        end
        left=[1;old(old(:,2)<=a,2)];
        right=[16;old(old(:,1)>=b,1)];
        score(s)=min(right)-max(left);
    end
    [best,s]=min(score);
    success=isfinite(best);
    if success
        booked{s}(end+1,:)=[a,b];
    else
        s=0;
    end
    result(k,:)=[requests(k,:),s,success];
end
disp(result)
disp([sum(result(:,6)),150-sum(result(:,6))])
