%%用字符分类和错误编号检查随机组合
clearvars
chars=['A':'Z','a':'z','0':'9','_'];
maxLength=namelengthmax;
words=cell(100,1);
for n=1:100
    words{n}=chars(randi(numel(chars),1,randi([1,maxLength+15])));
end
%错误位依次为:首字符不合法、长度超限、关键词、含非法字符。
%每行先输出序号和候选名,随后输出是否合法及4个错误位。
badFirst=cellfun(@(s)~isletter(s(1)),words);
badLength=cellfun(@(s)numel(s)>maxLength,words);
badKeyword=cellfun(@iskeyword,words);
badCharacter=cellfun(@(s)any(~(isletter(s)|(s>='0'&s<='9')|s=='_')),words);
mistakes=[badFirst,badLength,badKeyword,badCharacter];
ok=~any(mistakes,2);
for n=1:100
    fprintf('%d\t%s\t%d\t%d %d %d %d\n',n,words{n},ok(n),mistakes(n,:));
end

