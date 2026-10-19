rng(12);
kind=1;
plates=platesFromNumbers(kind);
disp(char(plates));

function plates=platesFromNumbers(kind)
symbols='0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
plates=cell(0,1);
while numel(plates)<10
    value=randi(34^5)-1;
    body='00000';
    for position=5:-1:1
        body(position)=symbols(mod(value,34)+1);
        value=floor(value/34);
    end
    letters=sum(body>='A'&body<='Z');
    if kind==1
        if letters>2
            continue
        end
        city='AV';
        candidate=['豫' city(randi(2)) body];
    else
        if letters>1
            continue
        end
        if kind==2
            category='ABCDE';
        else
            category='FG';
        end
        candidate=['豫A' category(randi(numel(category))) body];
    end
    if(~any(strcmp(plates,candidate)))
        plates{end+1,1}=candidate;
    end
end
end
