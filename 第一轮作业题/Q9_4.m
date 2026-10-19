phones=char(readcell('手机号.xlsx'));
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
