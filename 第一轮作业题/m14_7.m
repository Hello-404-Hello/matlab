% 同一轮中把各段空地一起随机分成两段，再处理下一轮。
% 输出平均数；[最小值,最大值,标准差]。
rng('shuffle');
count=zeros(1000,1);
for k=1:1000
    gaps=1000;
    number=0;
    while(~isempty(gaps))
        number=number+numel(gaps);
        space=gaps-2;
        left=rand(size(space)).*space;
        right=space-left;
        gaps=[left,right];
        gaps=gaps(gaps>=2);
    end
    count(k)=number;
end
disp(mean(count))
disp([min(count),max(count),std(count)])
