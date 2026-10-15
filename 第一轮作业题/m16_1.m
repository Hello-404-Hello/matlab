% 座位乘区段的逻辑表，按购票时刻从早到晚处理，优先分配小座号。
% 站序：北京、保定、石家庄、邢台、邯郸、安阳、新乡、郑州、
% 信阳、武汉、咸宁、长沙、株洲、衡阳、韶关、广州。
% 每行：[乘客编号,购票时刻(0到1),起站,终站,座号,成功标志]。
% 座号0表示失败；最后一行输出[成功人数,失败人数]。
rng('shuffle');
buyTime=rand(150,1);
trip=zeros(150,2);
for i=1:150
    trip(i,:)=sort(randperm(16,2));
end
[~,order]=sort(buyTime);
occupied=false(100,15);
report=zeros(150,6);
for k=1:150
    i=order(k);
    start=trip(i,1);
    finish=trip(i,2);
    segments=start:finish-1;
    seat=find(~any(occupied(:,segments),2),1);
    success=~isempty(seat);
    if success
        occupied(seat,segments)=true;
    else
        seat=0;
    end
    report(k,:)=[i,buyTime(i),start,finish,seat,success];
end
disp(report)
disp([sum(report(:,6)),150-sum(report(:,6))])
