a=randi([1,10],1,4);
disp(a)
s=jisuan(a,ones(1,4),arrayfun(@num2str,a,'UniformOutput',false));
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
function s=jisuan(p,q,t)
s='';
if numel(p)==1
    if p==24*q
        s=t{1};
    end
    return
end
for i=1:numel(p)-1
    for j=i+1:numel(p)
        use=true(size(p)); use([i,j])=false;
        fenzi=[p(i)*q(j)+p(j)*q(i),p(i)*q(j)-p(j)*q(i),p(j)*q(i)-p(i)*q(j),p(i)*p(j),p(i)*q(j),p(j)*q(i)];
        fenmu=[q(i)*q(j),q(i)*q(j),q(i)*q(j),q(i)*q(j),q(i)*p(j),q(j)*p(i)];
        tt={['(' t{i} '+' t{j} ')'],['(' t{i} '-' t{j} ')'],['(' t{j} '-' t{i} ')'],['(' t{i} '*' t{j} ')'],['(' t{i} '/' t{j} ')'],['(' t{j} '/' t{i} ')']};
        for k=6:-1:1
            if fenmu(k)==0
                continue
            end
            g=gcd(abs(fenzi(k)),abs(fenmu(k)));
            s=jisuan([p(use),fenzi(k)/g],[q(use),fenmu(k)/g],[t(use),tt(k)]);
            if ~isempty(s)
                return
            end
        end
    end
end
end
