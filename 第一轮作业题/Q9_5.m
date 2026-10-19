phones=char(readcell('手机号.xlsx'));

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
