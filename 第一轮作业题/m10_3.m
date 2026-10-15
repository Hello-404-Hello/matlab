% 互补字符映射。
% 两链按位置对齐，示例第4、11位错误；输出错误位置，全对输出0。
first='ATGCCGTATAGCGTACGATC';
second='TACGGCATATCGCATGCTAG';
second([4 11])='AU';

alphabet='ATGC';
partner='TACG';
n=max(numel(first),numel(second));
expect=repmat('?',1,n);
actual=repmat('-',1,n);
known=false(1,n);
[ok,where]=ismember(first,alphabet);
positions=find(ok);
expect(positions)=partner(where(ok));
known(positions)=true;
actual(1:numel(second))=second;
bad=find(~known|expect~=actual);
if numel(bad)==0
    disp(0);
else
    disp(bad);
end
