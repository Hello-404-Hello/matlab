% 滑窗与字符串查找。
% 输出两串共有的连续7位密码及第三串能否开锁（1或0）。
first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';

passwords=cell(0,1);
for i=1:length(first)-6
    candidate=first(i:i+6);
    if(~isempty(strfind(second,candidate))&&~any(strcmp(passwords,candidate)))
        passwords{end+1,1}=candidate;
    end
end
if isempty(passwords)
    disp(0);
else
    for i=1:numel(passwords)
        unlocked=~isempty(strfind(third,passwords{i}));
        fprintf('%s %d\n',passwords{i},unlocked);
    end
end
