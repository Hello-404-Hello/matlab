% 相邻数字作差，连续两个差为0就有三连数字。
% phones每行11位；下面生成100个示例号码。
rng(9);
phones=char(randi([0 9],100,11)+'0');
phones(:,1)='1';
phones(:,2)=char(randi([3 9],100,1)+'0');
phones(1,:)='13811124567';
phones(2,:)='13988801234';

difference=diff(double(phones),1,2);
same=difference==0;
selected=any(same(:,1:end-1)&same(:,2:end),2);
disp(phones(selected,:));
