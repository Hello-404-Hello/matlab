% 函数内用switch逐位判断四种配对。
% 两链按位置对齐，输出错误位置，全对输出0。
first='ATGCCGTATAGCGTACGATC';
second='TACGGCATATCGCATGCTAG';
second([4 11])='AU';
bad=findWrongPairs(first,second);
if isempty(bad)
    disp(0);
else
    disp(bad);
end

function bad=findWrongPairs(first,second)
right=false(1,max(numel(first),numel(second)));
for position=1:min(numel(first),numel(second))
    switch first(position)
        case 'A'
            right(position)=second(position)=='T';
        case 'T'
            right(position)=second(position)=='A';
        case 'G'
            right(position)=second(position)=='C';
        case 'C'
            right(position)=second(position)=='G';
    end
end
bad=find(~right);
end
