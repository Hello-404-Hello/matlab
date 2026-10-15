% 逐个座位检查，每次把可选座位的检查顺序打乱，模拟随机分座。
% 半开区间[a,b)允许前一位在b站下车、后一位在b站上车。
% 输出每行：[乘客编号,购票时刻,起站,终站,座号,成功标志]。
% 最后一行是[成功人数,失败人数]。
rng('shuffle');
data=zeros(150,4);
for i=1:150
    a=randi(16);
    b=randi(16);
    while a==b
        b=randi(16);
    end
    data(i,:)=[i,rand,min(a,b),max(a,b)];
end
data=sortrows(data,2);
taken=zeros(100,15);
out=zeros(150,6);
for i=1:150
    a=data(i,3);
    b=data(i,4);
    seats=randperm(100);
    number=0;
    for j=1:100
        s=seats(j);
        good=1;
        for part=a:b-1
            if taken(s,part)==1
                good=0;
                break
            end
        end
        if good==1
            number=s;
            for part=a:b-1
                taken(s,part)=1;
            end
            break
        end
    end
    out(i,:)=[data(i,:),number,number>0];
end
disp(out)
passed=sum(out(:,6));
disp([passed,150-passed])
