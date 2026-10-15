% 连续重复计数。
% phones每行11位；下面生成100个示例号码，输出含三连数字的号码。
rng(9);
phones=char(randi([0 9],100,11)+'0');
phones(:,1)='1';
phones(:,2)=char(randi([3 9],100,1)+'0');
phones(1,:)='13811124567';
phones(2,:)='13988801234';
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
