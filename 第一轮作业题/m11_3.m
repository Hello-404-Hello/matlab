% 七位滚动整数编码。
% 输出两串共有的连续7位密码及第三串能否开锁（1或0）。
first='2345978552799476461323';
second='8467652799471386547216';
third='5527994568768152487863';
data={first,second,third};
codes=cell(1,3);
for k=1:3
    text=data{k};
    values=zeros(1,max(length(text)-6,0));
    value=0;
    for j=1:length(text)
        value=mod(value,1000000)*10+double(text(j))-'0';
        if j>=7
            values(j-6)=value;
        end
    end
    codes{k}=values;
end
keys=intersect(codes{1},codes{2});
if isempty(keys)
    disp(0);
else
    for i=1:length(keys)
        fprintf('%07d %d\n',keys(i),any(codes{3}==keys(i)));
    end
end
