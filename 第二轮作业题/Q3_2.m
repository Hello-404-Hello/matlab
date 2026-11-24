rng(13,'twister')
c=cell(3,1);
for k=1:3
    c{k}=randi([0,100],60,3);
end
a=c{1};
s=a(:,1)+a(:,2)+a(:,3);
[~,p]=sort(s,'descend');
fprintf(' 名次  学号  科1   科2   科3   总分\n')
for j=1:60
    i=p(j);
    n=nnz(s>s(i))+1;
    fprintf('%4d %5d %5d %5d %5d %5d\n',n,i,a(i,:),s(i))
end
fprintf(' 科目      均分       方差   优秀人数\n')
for j=1:3
    x=a(:,j);
    m=sum(x)/60;
    v=sum((x-m).^2)/59;
    fprintf('%4d %9.2f %10.2f %7d\n',j,m,v,nnz(x>=85))
end
m=zeros(3,1);
for j=1:3
    x=sort(sum(c{j},2));
    m(j)=(x(30)+x(31))/2;
    fprintf('%d 班总分中位数 %.1f\n',j,m(j))
end
fprintf('最优班级')
fprintf(' %d',find(m==max(m)))
fprintf('\n')
