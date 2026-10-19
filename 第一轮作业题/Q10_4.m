basePairLines=readlines('碱基对.txt');
first=char(basePairLines(2));
second=char(basePairLines(4));
pairs=[first(:) second(:)];
legal=['AT';'TA';'GC';'CG'];
isRight=ismember(pairs,legal,'rows');
bad=find(~isRight).';
if isempty(bad)
    disp(0);
else
    disp(bad);
end
