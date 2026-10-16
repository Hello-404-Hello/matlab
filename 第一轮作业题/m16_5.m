rng('shuffle');
requests=zeros(150,4);
for i=1:150
    route=sort(randperm(16,2));
    requests(i,:)=[i,rand,route];
end
requests=sortrows(requests,2);
free=repmat({[1,16]},100,1);
report=zeros(150,6);
for person=1:150
    a=requests(person,3);
    b=requests(person,4);
    chosenSeat=0;
    chosenGap=0;
    fewest=3;
    for s=1:100
        intervals=free{s};
        for k=1:size(intervals,1)
            if a>=intervals(k,1)&&b<=intervals(k,2)
                pieces=(a>intervals(k,1))+(b<intervals(k,2));
                if pieces<fewest
                    fewest=pieces;
                    chosenSeat=s;
                    chosenGap=k;
                end
            end
        end
    end
    if chosenSeat>0
        remaining=free{chosenSeat};
        gap=remaining(chosenGap,:);
        remaining(chosenGap,:)=[];
        if a>gap(1)
            remaining(end+1,:)=[gap(1),a];
        end
        if b<gap(2)
            remaining(end+1,:)=[b,gap(2)];
        end
        free{chosenSeat}=sortrows(remaining,1);
    end
    report(person,:)=[requests(person,:),chosenSeat,chosenSeat>0];
end
disp(report)
disp([sum(report(:,6)),150-sum(report(:,6))])
