% 按数字变化位置分段，找长度至少为3的连续段。
% numbers每行11位，输出含三连数字的号码。
rng(9);
numbers=char(randi([0 9],100,11)+'0');
numbers(:,1)='1';
numbers(:,2)=char(randi([3 9],100,1)+'0');
numbers(1,:)='13811124567';
numbers(2,:)='13988801234';
chosen=selectTriple(numbers);
disp(numbers(chosen,:));

function chosen=selectTriple(numbers)
chosen=false(size(numbers,1),1);
for row=1:size(numbers,1)
    text=numbers(row,:);
    changes=find(text(2:end)~=text(1:end-1))+1;
    starts=[1 changes numel(text)+1];
    lengths=diff(starts);
    chosen(row)=any(lengths>=3);
end
end
