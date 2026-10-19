basePairLines=readlines('碱基对.txt');
first=char(basePairLines(2));
second=char(basePairLines(4));

wrong=[];
for k=1:length(first)
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
