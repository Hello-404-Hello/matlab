phones=char(readcell('手机号.xlsx'));

difference=diff(double(phones),1,2);
same=difference==0;
selected=any(same(:,1:end-1)&same(:,2:end),2);
disp(phones(selected,:));
