% 补齐后向量比较。
% 两链按位置对齐，示例第4、11位错误；输出错误位置，全对输出0。
first='ATGCCGTATAGCGTACGATC';
second='TACGGCATATCGCATGCTAG';
second([4 11])='AU';
len=max(numel(first),numel(second));
s1=repmat('-',1,len);
s2=repmat('-',1,len);
s1(1:numel(first))=first;
s2(1:numel(second))=second;
paired=(s1=='A'&s2=='T')|(s1=='T'&s2=='A')|(s1=='G'&s2=='C')|(s1=='C'&s2=='G');
bad=find(~paired);
if isempty(bad)
    disp(0);
else
    disp(bad);
end
