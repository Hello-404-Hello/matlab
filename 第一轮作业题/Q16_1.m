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
