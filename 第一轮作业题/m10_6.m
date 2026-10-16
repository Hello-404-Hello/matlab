basePairLines=readlines('碱基对.txt');
first=char(basePairLines(2));
second=char(basePairLines(4));
bad=findWrongPairs(first,second);
if isempty(bad)
    disp(0);
else
    disp(bad);
end

function bad=findWrongPairs(first,second)
right=false(1,numel(first));
for position=1:numel(first)
    switch first(position)
        case 'A'
            right(position)=second(position)=='T';
        case 'T'
            right(position)=second(position)=='A';
        case 'G'
            right(position)=second(position)=='C';
        case 'C'
            right(position)=second(position)=='G';
    end
end
bad=find(~right);
end
