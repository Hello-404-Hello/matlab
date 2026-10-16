numbers=char(readcell('手机号.xlsx'));
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
