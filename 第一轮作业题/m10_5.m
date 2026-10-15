% 配对表双循环。
% 两链按位置对齐，示例第4、11位错误；输出错误位置，全对输出0。
first='ATGCCGTATAGCGTACGATC';
second='TACGGCATATCGCATGCTAG';
second([4 11])='AU';
left='ATGC';
right='TACG';
correct=false(1,max(numel(first),numel(second)));
for position=1:min(numel(first),numel(second))
    for rule=1:4
        if first(position)==left(rule)&&second(position)==right(rule)
            correct(position)=true;
            break
        end
    end
end
bad=find(~correct);
if isempty(bad)
    disp(0);
else
    disp(bad);
end
