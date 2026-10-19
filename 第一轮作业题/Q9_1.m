phones=char(readcell('手机号.xlsx'));
choose=false(size(phones,1),1);
for i=1:size(phones,1)
    for j=1:size(phones,2)-2
        if phones(i,j)==phones(i,j+1)&&phones(i,j+1)==phones(i,j+2)
            choose(i)=true;
            break
        end
    end
end
disp(phones(choose,:));
