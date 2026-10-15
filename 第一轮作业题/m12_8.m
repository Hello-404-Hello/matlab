% 列出允许的字母位置模式，再随机选择一种模式填入字符。
% kind为1燃油、2纯电、3混动，输出10个不同车牌。
rng(12);
kind=1;
plates=platesFromMasks(kind);
for row=1:10
    fprintf('%s\n',plates{row});
end

function plates=platesFromMasks(kind)
letters='ABCDEFGHJKLMNPQRSTUVWXYZ';
masks=dec2bin(0:31,5)-'0';
if kind==1
    masks=masks(sum(masks,2)<=2,:);
else
    masks=masks(sum(masks,2)<=1,:);
end
plates=cell(0,1);
while numel(plates)<10
    mask=masks(randi(size(masks,1)),:);
    body='00000';
    for position=1:5
        if mask(position)==1
            body(position)=letters(randi(numel(letters)));
        else
            body(position)=char('0'+randi([0 9]));
        end
    end
    switch kind
        case 1
            city='AV';
            head=['豫' city(randi(2))];
        case 2
            category='ABCDE';
            head=['豫A' category(randi(5))];
        case 3
            category='FG';
            head=['豫A' category(randi(2))];
    end
    candidate=[head body];
    if(~any(strcmp(plates,candidate)))
        plates{end+1,1}=candidate;
    end
end
end
