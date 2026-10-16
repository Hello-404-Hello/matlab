rng(12);
model=1;
choices=plate_candidates_shuffle(model);
for i=1:10
    fprintf('%s\n',choices{i});
end

function choices=plate_candidates_shuffle(model)
letters='ABCDEFGHJKLMNPQRSTUVWXYZ';
choices=cell(10,1);
for i=1:10
    repeated=true;
    while repeated
        if model==1
            digitCount=randi([3 5]);
        else
            digitCount=randi([4 5]);
        end
        digits=char('0'+randi([0 9],1,digitCount));
        chars=letters(randi(numel(letters),1,5-digitCount));
        tail=[digits chars];
        tail=tail(randperm(5));
        switch model
            case 1
                cityLetters='AV';
                plate=['豫' cityLetters(randi(2)) tail];
            case 2
                category='ABCDE';
                plate=['豫A' category(randi(5)) tail];
            case 3
                category='FG';
                plate=['豫A' category(randi(2)) tail];
        end
        repeated=any(strcmp(choices(1:i-1),plate));
    end
    choices{i}=plate;
end
end
