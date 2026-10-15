% 把每一段的空座号求交集，优先选择能与已有乘车区间衔接的座位。
% 输出[乘客号,购票时刻,起站,终站,座号,成功标志]，最后输出成功/失败人数。
rng('shuffle');
t=rand(150,1);
route=zeros(150,2);
for k=1:150
    route(k,:)=sort(randperm(16,2));
end
[~,sequence]=sort(t);
taken=false(100,15);
report=zeros(150,6);
for k=1:150
    person=sequence(k);
    a=route(person,1);
    b=route(person,2);
    choices=1:100;
    for part=a:b-1
        choices=intersect(choices,find(~taken(:,part))');
    end
    s=0;
    if(~isempty(choices))
        touch=zeros(size(choices));
        for j=1:numel(choices)
            seat=choices(j);
            if a>1
                touch(j)=touch(j)+taken(seat,a-1);
            end
            if b<=15
                touch(j)=touch(j)+taken(seat,b);
            end
        end
        [~,index]=max(touch);
        s=choices(index);
        taken(s,a:b-1)=true;
    end
    report(k,:)=[person,t(person),a,b,s,s>0];
end
fprintf('%d %.4f %d %d %d %d\n',report');
fprintf('%d %d\n',sum(report(:,6)),150-sum(report(:,6)));
