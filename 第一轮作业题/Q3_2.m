clearvars
chars=['A':'Z','a':'z','0':'9','_'];
maxLength=namelengthmax;
words=cell(100,1);
for n=1:100
    words{n}=chars(randi(numel(chars),1,randi([1,maxLength+15])));
end
badFirst=cellfun(@(s)~isletter(s(1)),words);
badLength=cellfun(@(s)numel(s)>maxLength,words);
badKeyword=cellfun(@iskeyword,words);
badCharacter=cellfun(@(s)any(~(isletter(s)|(s>='0'&s<='9')|s=='_')),words);
mistakes=[badFirst,badLength,badKeyword,badCharacter];
ok=~any(mistakes,2);
for n=1:100
    fprintf('%d\t%s\t%d\t%d %d %d %d\n',n,words{n},ok(n),mistakes(n,:));
end
