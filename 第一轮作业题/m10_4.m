% 碱基对集合匹配。
% 两链按位置对齐，示例第4、11位错误；输出错误位置，全对输出0。
first='ATGCCGTATAGCGTACGATC';
second='TACGGCATATCGCATGCTAG';
second([4 11])='AU';
total=max(numel(first),numel(second));
left=repmat('-',1,total);
right=repmat('-',1,total);
left(1:numel(first))=first;
right(1:numel(second))=second;
pairs=[left(:) right(:)];
legal=['AT';'TA';'GC';'CG'];
isRight=ismember(pairs,legal,'rows');
bad=find(~isRight).';
if isempty(bad)
    disp(0);
else
    disp(bad);
end
