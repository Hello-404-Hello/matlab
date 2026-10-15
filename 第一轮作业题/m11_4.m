% 朴素双滑窗匹配。
% 输出两串共有的连续7位密码及第三串能否开锁（1或0）。
first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';

passwords=cell(0,1);
for p=1:length(first)-6
    key=first(p:p+6);
    matched=false;
    for q=1:length(second)-6
        if all(key==second(q:q+6))
            matched=true;
            break
        end
    end
    if matched&&~any(strcmp(passwords,key))
        passwords{end+1,1}=key;
    end
end
if isempty(passwords)
    disp(0);
else
    for p=1:numel(passwords)
        success=0;
        for q=1:length(third)-6
            if all(passwords{p}==third(q:q+6))
                success=1;
                break
            end
        end
        fprintf('%s %d\n',passwords{p},success);
    end
end
