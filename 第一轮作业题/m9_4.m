% 按数字批量查找。
% phones每行11位；下面生成100个示例号码，输出含三连数字的号码。
rng(9);
phones=char(randi([0 9],100,11)+'0');
phones(:,1)='1';
phones(:,2)=char(randi([3 9],100,1)+'0');
phones(1,:)='13811124567';
phones(2,:)='13988801234';
result=false(size(phones,1),1);
for digit='0':'9'
    target=repmat(digit,1,3);
    for line=1:size(phones,1)
        if(~isempty(strfind(phones(line,:),target)))
            result(line)=true;
        end
    end
end
disp(phones(result,:));
