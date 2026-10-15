% 每一对碱基拼成两个字符，再和四种合法配对逐一比较。
% 两链按位置对齐，输出错误位置，全对输出0。
left='ATGCCGTATAGCGTACGATC';
right='TACGGCATATCGCATGCTAG';
right([4 11])='AU';
rules={'AT','TA','GC','CG'};
matched=false(1,max(numel(left),numel(right)));
for index=1:min(numel(left),numel(right))
    pair=[left(index) right(index)];
    for rule=1:4
        if strcmp(pair,rules{rule})
            matched(index)=true;
            break
        end
    end
end
bad=find(~matched);
if isempty(bad)
    disp(0);
else
    disp(bad);
end
