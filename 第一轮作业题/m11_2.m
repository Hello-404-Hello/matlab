% 窗口集合交集。
% 输出两串共有的连续7位密码及第三串能否开锁（1或0）。
first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';
strings={first,second,third};
windows=cell(1,3);
for k=1:3
    s=strings{k};
    windows{k}=cell(max(numel(s)-6,0),1);
    for j=1:numel(s)-6
        windows{k}{j}=s(j:j+6);
    end
end
common=intersect(windows{1},windows{2},'stable');
canOpen=ismember(common,windows{3});
if isempty(common)
    disp(0);
else
    for k=1:numel(common)
        fprintf('%s %d\n',common{k},canOpen(k));
    end
end
