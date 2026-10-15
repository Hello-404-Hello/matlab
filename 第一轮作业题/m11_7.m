% 三层循环逐个字符比较两个7位窗口。
% 每行输出候选密码及第三串能否开锁（1或0）。
first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';
passwords=cell(0,1);
for start1=1:numel(first)-6
    for start2=1:numel(second)-6
        count=0;
        for offset=0:6
            if first(start1+offset)~=second(start2+offset)
                break
            end
            count=count+1;
        end
        if count==7
            key=first(start1:start1+6);
            if(~any(strcmp(passwords,key)))
                passwords{end+1,1}=key;
            end
            break
        end
    end
end
canOpen=false(numel(passwords),1);
for candidate=1:numel(passwords)
    key=passwords{candidate};
    for start3=1:numel(third)-6
        count=0;
        for offset=0:6
            if key(offset+1)~=third(start3+offset)
                break
            end
            count=count+1;
        end
        if count==7
            canOpen(candidate)=true;
            break
        end
    end
end
if isempty(passwords)
    disp(0);
else
    for candidate=1:numel(passwords)
        fprintf('%s %d\n',passwords{candidate},canOpen(candidate));
    end
end
