first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';
table=zeros(numel(first)+1,numel(second)+1);
passwords=cell(0,1);
for i=1:numel(first)
    for j=1:numel(second)
        if first(i)==second(j)
            table(i+1,j+1)=table(i,j)+1;
            if table(i+1,j+1)>=7
                candidate=first(i-6:i);
                if(~any(strcmp(passwords,candidate)))
                    passwords{end+1,1}=candidate;
                end
            end
        end
    end
end
canOpen=false(numel(passwords),1);
for i=1:numel(passwords)
    canOpen(i)=contains(third,passwords{i});
end
if isempty(passwords)
    disp(0);
else
    for i=1:numel(passwords)
        fprintf('%s %d\n',passwords{i},canOpen(i));
    end
end
