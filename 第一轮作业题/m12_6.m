% 逐位生成并记录字母数；单个候选和十个候选分别封装。
% kind为1燃油、2纯电、3混动，输出10个不同车牌。
rng(12);
kind=1;
plates=chooseTen(kind);
fprintf('%s\n',plates{:});

function plates=chooseTen(kind)
plates=cell(0,1);
while numel(plates)<10
    candidate=onePlate(kind);
    if(~any(strcmp(plates,candidate)))
        plates{end+1,1}=candidate;
    end
end
end

function candidate=onePlate(kind)
letters='ABCDEFGHJKLMNPQRSTUVWXYZ';
if kind==1
    city='AV';
    head=['豫' city(randi(2))];
    count=0;
else
    if kind==2
        category='ABCDE';
    else
        category='FG';
    end
    head=['豫A' category(randi(numel(category)))];
    count=1;
end
body='00000';
for position=1:5
    if count<2&&rand<0.25
        body(position)=letters(randi(numel(letters)));
        count=count+1;
    else
        body(position)=char('0'+randi([0 9]));
    end
end
candidate=[head body];
end
