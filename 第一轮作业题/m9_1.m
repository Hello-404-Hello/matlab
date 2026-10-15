% 相邻三位双循环。
% phones每行11位；下面生成100个示例号码，输出含三连数字的号码。
rng(9);
phones=char(randi([0 9],100,11)+'0');
phones(:,1)='1';
phones(:,2)=char(randi([3 9],100,1)+'0');
phones(1,:)='13811124567';
phones(2,:)='13988801234';
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
