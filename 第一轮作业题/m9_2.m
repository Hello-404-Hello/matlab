% 矩阵逐元素比较。
% phones每行11位；下面生成100个示例号码，输出含三连数字的号码。
rng(9);
phones=char(randi([0 9],100,11)+'0');
phones(:,1)='1';
phones(:,2)=char(randi([3 9],100,1)+'0');
phones(1,:)='13811124567';
phones(2,:)='13988801234';
same=(phones(:,1:end-2)==phones(:,2:end-1))&(phones(:,2:end-1)==phones(:,3:end));
selected=any(same,2);
disp(phones(selected,:));
