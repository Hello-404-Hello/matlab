phones=char(readcell('手机号.xlsx'));
for k=1:size(phones,1)
    times=1;
    for t=2:size(phones,2)
        if phones(k,t)==phones(k,t-1)
            times=times+1;
        else
            times=1;
        end
        if times>=3
            disp(phones(k,:));
            break
        end
    end
end
