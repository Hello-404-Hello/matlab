rng(12);
kind=1;
plates=platesByPositions(kind);
for row=1:10
    disp(plates{row});
end

function plates=platesByPositions(kind)
letters='ABCDEFGHJKLMNPQRSTUVWXYZ';
plates=cell(10,1);
if kind==1
    limit=2;
else
    limit=1;
end
for row=1:10
    repeated=true;
    while repeated
        flags=false(1,5);
        count=randi([0 limit]);
        order=randperm(5);
        flags(order(1:count))=true;
        body='00000';
        for position=1:5
            if flags(position)
                body(position)=letters(randi(numel(letters)));
            else
                body(position)=char('0'+randi([0 9]));
            end
        end
        if kind==1
            city='AV';
            candidate=['豫' city(randi(2)) body];
        elseif kind==2
            category='ABCDE';
            candidate=['豫A' category(randi(5)) body];
        else
            category='FG';
            candidate=['豫A' category(randi(2)) body];
        end
        repeated=false;
        for previous=1:row-1
            if strcmp(plates{previous},candidate)
                repeated=true;
                break
            end
        end
    end
    plates{row}=candidate;
end
end
