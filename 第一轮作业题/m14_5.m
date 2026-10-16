rng('shuffle');
result=zeros(600,1);
for trial=1:600
    positions=[];
    while true
        positions=sort(positions);
        begin=[0,positions+2];
        finish=[positions,1000];
        possible=find(finish-begin>=2);
        if isempty(possible)
            break
        end
        lengths=finish(possible)-begin(possible)-2;
        total=sum(lengths);
        if total==0
            index=possible(1);
            newPlace=begin(index);
        else
            select=find(cumsum(lengths)>rand*total,1);
            index=possible(select);
            newPlace=begin(index)+rand*lengths(select);
        end
        positions(end+1)=newPlace;
    end
    result(trial)=numel(positions);
end
average=mean(result);
width=1.96*std(result)/sqrt(numel(result));
disp(average)
disp([average-width,average+width])
figure;
hold on;
for k=1:numel(positions)
    rectangle('Position',[positions(k),0,2,2],'FaceColor',[0.2,0.65,0.4]);
end
xlim([0,1000]);
ylim([0,2]);
hold off;
