%%分别标记数字开头、下划线开头、超长和关键词
clear
characters=['0':'9','_','A':'Z','a':'z'];
candidate=cell(100,1);
errorFlags=false(100,4);
legal=false(100,1);
%每行:候选名、是否合法、四个错误标志。
%错误标志依次为数字开头、下划线开头、长度超限、属于关键词。
for j=1:100
    lengthHere=randi([1,100]);
    word=characters(randi(63,1,lengthHere));
    candidate{j}=word;
    first=double(word(1));
    errorFlags(j,1)=first>=48&&first<=57;
    errorFlags(j,2)=word(1)=='_';
    errorFlags(j,3)=lengthHere>namelengthmax;
    errorFlags(j,4)=iskeyword(word);
    legal(j)=~any(errorFlags(j,:));
    fprintf('%s\t%d\t%d %d %d %d\n',word,legal(j),errorFlags(j,:));
end

