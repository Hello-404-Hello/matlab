rng('shuffle');
orders=zeros(150,4);
for passenger=1:150
    stops=sort(randperm(16,2));
    orders(passenger,:)=[passenger,rand,stops];
end
orders=sortrows(orders,2);
busy=false(100,15);
report=zeros(150,6);
for i=1:150
    a=orders(i,3);
    b=orders(i,4);
    available=find(~any(busy(:,a:b-1),2));
    seat=0;
    if(~isempty(available))
        used=sum(busy(available,:),2);
        [~,k]=max(used);
        seat=available(k);
        busy(seat,a:b-1)=true;
    end
    report(i,:)=[orders(i,:),seat,seat>0];
end
fprintf('%d %.5f %d %d %d %d\n',report');
fprintf('%d %d\n',sum(report(:,6)),150-sum(report(:,6)));
