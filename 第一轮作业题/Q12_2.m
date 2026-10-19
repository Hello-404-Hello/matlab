rng(12);
kind=1;
answer=plate_candidates_place(kind);
fprintf('%s\n',answer{:});

function list=plate_candidates_place(kind)
abc='ABCDEFGHJKLMNPQRSTUVWXYZ';
head={'豫A','豫V'};
list=cell(10,1);
count=0;
while count<10
    body=char('0'+randi([0 9],1,5));
    if kind==1
        nLetters=randi([0 2]);
        pos=randperm(5,nLetters);
        body(pos)=abc(randi(numel(abc),1,nLetters));
        newPlate=[head{randi(2)} body];
    else
        if kind==2
            leading='ABCDE';
        else
            leading='FG';
        end
        if randi([0 1])==1
            body(randi(5))=abc(randi(numel(abc)));
        end
        newPlate=['豫A' leading(randi(numel(leading))) body];
    end
    if(~any(strcmp(list(1:count),newPlate)))
        count=count+1;
        list{count}=newPlate;
    end
end
end
