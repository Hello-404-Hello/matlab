rng(13,'twister')
fen=randi([0,100],60,3,3);
a=fen(:,:,1);
tong=paiming(a);
tong.Properties.VariableNames={'ID','S1','S2','S3','Total','Rank'};
disp(sortrows(tong,{'Rank','ID'}))
m=zeros(3,1);
v=m;
u=m;
for i=1:3
    d=a(:,i);
    m(i)=mean(d);
    v(i)=dot(d-m(i),d-m(i))/59;
    u(i)=numel(find(d>=85));
end
disp(table((1:3)',m,v,u,'VariableNames',{'Subject','Mean','Variance','Excellent'}))
q=zeros(1,3);
for i=1:3
    d=sort(sum(fen(:,:,i),2));
    q(i)=d(ceil(numel(d)/4));
end
fprintf('各班总分下四分位数（最近秩法）\n')
disp(q)
fprintf('最优班级')
fprintf(' %d',find(q==max(q)))
fprintf('\n')

function a=paiming(x)
s=sum(x,2);
[score,idx]=sort(s,'descend');
r=zeros(size(s));
j=1;
for i=1:numel(s)
    if i>1&&score(i)<score(i-1)
        j=i;
    end
    r(idx(i))=j;
end
a=array2table([(1:numel(s))',x,s,r]);
end
