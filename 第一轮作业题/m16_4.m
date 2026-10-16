rng('shuffle');
orders=zeros(150,4);
for person=1:150
    ends=sort(randperm(16,2));
    orders(person,:)=[person,rand,ends];
end
orders=sortrows(orders,2);
seatMask=zeros(100,1,'uint16');
answer=zeros(150,6);
for k=1:150
    a=orders(k,3);
    b=orders(k,4);
    need=uint16(0);
    for segment=a:b-1
        need=bitset(need,segment,1);
    end
    seat=find(bitand(seatMask,need)==0,1);
    accepted=~isempty(seat);
    if accepted
        seatMask(seat)=bitor(seatMask(seat),need);
    else
        seat=0;
    end
    answer(k,:)=[orders(k,:),seat,accepted];
end
disp(answer)
disp([sum(answer(:,6)),150-sum(answer(:,6))])
