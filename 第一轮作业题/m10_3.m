basePairLines=readlines('碱基对.txt');
first=char(basePairLines(2));
second=char(basePairLines(4));

alphabet='ATGC';
partner='TACG';
[~,where]=ismember(first,alphabet);
expect=partner(where);
bad=find(expect~=second);
if numel(bad)==0
    disp(0);
else
    disp(bad);
end
