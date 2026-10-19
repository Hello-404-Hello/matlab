rng(12);
type=1;
result=plate_candidates_batch(type);
disp(char(result));

function answer=plate_candidates_batch(type)
symbols='0123456789ABCDEFGHJKLMNPQRSTUVWXYZ';
answer=cell(0,1);
while numel(answer)<10
    block=symbols(randi(numel(symbols),200,5));
    nAlpha=sum(block>='A'&block<='Z',2);
    if type==1
        block=block(nAlpha<=2,:);
        head={'豫A','豫V'};
        prefixes=head(randi(2,size(block,1),1));
        candidates=strcat(prefixes(:),cellstr(block));
    else
        block=block(nAlpha<=1,:);
        if type==2
            letter='ABCDE';
        else
            letter='FG';
        end
        leading=letter(randi(numel(letter),size(block,1),1));
        tail=[leading(:) block];
        candidates=strcat('豫A',cellstr(tail));
    end
    answer=unique([answer;candidates(:)],'stable');
end
answer=answer(1:10);
end
