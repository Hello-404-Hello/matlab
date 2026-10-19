basePairLines=readlines('碱基对.txt');
left=char(basePairLines(2));
right=char(basePairLines(4));
rules={'AT','TA','GC','CG'};
matched=false(1,numel(left));
for index=1:numel(left)
    pair=[left(index) right(index)];
    for rule=1:4
        if strcmp(pair,rules{rule})
            matched(index)=true;
            break
        end
    end
end
bad=find(~matched);
if isempty(bad)
    disp(0);
else
    disp(bad);
end
