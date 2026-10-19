basePairLines=readlines('碱基对.txt');
first=char(basePairLines(2));
second=char(basePairLines(4));
left='ATGC';
right='TACG';
correct=false(1,numel(first));
for position=1:numel(first)
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
