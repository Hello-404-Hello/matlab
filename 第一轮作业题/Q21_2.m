a=randi([1,10],1,4);
disp(a)
s=fenshu(a,ones(1,4),arrayfun(@num2str,a,'UniformOutput',false));
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
function s=fenshu(p,q,t)
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
        pp=[p(i)*q(j)+p(j)*q(i),p(i)*q(j)-p(j)*q(i),p(j)*q(i)-p(i)*q(j),p(i)*p(j),p(i)*q(j),p(j)*q(i)];
        qq=[q(i)*q(j),q(i)*q(j),q(i)*q(j),q(i)*q(j),q(i)*p(j),q(j)*p(i)];
        tt={['(' t{i} '+' t{j} ')'],['(' t{i} '-' t{j} ')'],['(' t{j} '-' t{i} ')'],['(' t{i} '*' t{j} ')'],['(' t{i} '/' t{j} ')'],['(' t{j} '/' t{i} ')']};
        for k=1:6
            if qq(k)==0
                continue
            end
            g=gcd(abs(pp(k)),abs(qq(k)));
            s=fenshu([p(use),pp(k)/g],[q(use),qq(k)/g],[t(use),tt(k)]);
            if ~isempty(s)
                return
            end
        end
    end
end
end
