rng('shuffle');
data=zeros(150,4);
for k=1:150
    from=randi(15);
    to=randi([from+1,16]);
    data(k,:)=[k,rand,from,to];
end
data=sortrows(data,2);
report=buy(data,100);
disp(report)
disp([sum(report(:,6)),150-sum(report(:,6))])

function result=buy(data,seats)
old=cell(seats,1);
result=zeros(size(data,1),6);
for i=1:size(data,1)
    a=data(i,3);
    b=data(i,4);
    selected=0;
    for seat=seats:-1:1
        trips=old{seat};
        if isempty(trips)
            selected=seat;
        elseif(~any(trips(:,1)<b&trips(:,2)>a))
            selected=seat;
        end
        if selected>0
            old{selected}(end+1,:)=[a,b];
            break
        end
    end
    result(i,:)=[data(i,:),selected,selected>0];
end
end
