phones=char(readcell('手机号.xlsx'));
same=(phones(:,1:end-2)==phones(:,2:end-1))&(phones(:,2:end-1)==phones(:,3:end));
selected=any(same,2);
disp(phones(selected,:));
