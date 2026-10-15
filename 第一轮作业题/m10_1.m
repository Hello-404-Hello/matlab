% 逐位布尔判断。
% 两链按位置对齐，示例第4、11位错误；输出错误位置，全对输出0。
first='ATGCCGTATAGCGTACGATC';
second='TACGGCATATCGCATGCTAG';
second([4 11])='AU';

wrong=[];
for k=1:max(length(first),length(second))
    if k>length(first)||k>length(second)
        wrong(end+1)=k;
        continue
    end
    a=first(k);
    b=second(k);
    right=(a=='A'&&b=='T')||(a=='T'&&b=='A')||(a=='G'&&b=='C')||(a=='C'&&b=='G');
    if(~right)
        wrong(end+1)=k;
    end
end
if isempty(wrong)
    disp(0);
else
    disp(wrong);
end
