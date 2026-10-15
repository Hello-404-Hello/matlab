% 逐号拒绝采样。
% 车型1燃油、2纯电、3混动；输出10个不同车牌。
rng(12);
carType=1;
plates=plate_candidates_reject(carType);
for k=1:numel(plates)
    disp(plates{k});
end

function plates=plate_candidates_reject(carType)
letters='ABCDEFGHJKLMNPQRSTUVWXYZ';
pool=['0123456789' letters];
prefixes={'豫A','豫V'};
plates=cell(10,1);
number=0;
while number<10
    tail='';
    for j=1:5
        tail(j)=pool(randi(length(pool)));
    end
    letterCount=sum(tail>='A'&tail<='Z');
    if carType==1
        if letterCount>2
            continue
        end
        candidate=[prefixes{randi(2)} tail];
    else
        if letterCount>1
            continue
        end
        if carType==2
            firstLetters='ABCDE';
        else
            firstLetters='FG';
        end
        candidate=['豫A' firstLetters(randi(length(firstLetters))) tail];
    end
    if any(strcmp(plates(1:number),candidate))
        continue
    end
    number=number+1;
    plates{number}=candidate;
end
end
