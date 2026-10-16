first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';
windows1=sevenWindows(first);
windows2=sevenWindows(second);
windows3=sevenWindows(third);
passwords=intersect(windows1,windows2,'rows','stable');
canOpen=ismember(passwords,windows3,'rows');
if isempty(passwords)
    disp(0);
else
    for row=1:size(passwords,1)
        fprintf('%s %d\n',passwords(row,:),canOpen(row));
    end
end

function windows=sevenWindows(text)
indices=(1:7)+(0:numel(text)-7).';
windows=text(indices);
end
