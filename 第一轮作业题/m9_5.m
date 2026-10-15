% 按号码查找，命中后提前退出。
% phones每行11位；下面生成100个示例号码，输出含三连数字的号码。
rng(9);
phones=char(randi([0 9],100,11)+'0');
phones(:,1)='1';
phones(:,2)=char(randi([3 9],100,1)+'0');
phones(1,:)='13811124567';
phones(2,:)='13988801234';

selected=false(size(phones,1),1);
for row=1:size(phones,1)
    for digit='0':'9'
        pattern=[digit digit digit];
        if(~isempty(strfind(phones(row,:),pattern)))
            selected(row)=true;
            break
        end
    end
end
disp(phones(selected,:));
