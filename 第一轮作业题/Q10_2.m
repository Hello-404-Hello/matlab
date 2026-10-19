basePairLines=readlines('碱基对.txt');
first=char(basePairLines(2));
second=char(basePairLines(4));
paired=(first=='A'&second=='T')|(first=='T'&second=='A')|(first=='G'&second=='C')|(first=='C'&second=='G');
bad=find(~paired);
if isempty(bad)
    disp(0);
else
    disp(bad);
end
