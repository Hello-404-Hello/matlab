a=randi([1,10],1,4);
disp(a)
queue={a}; words={arrayfun(@num2str,a,'UniformOutput',false)};
pos=1; s='';
while pos<=numel(queue)
    b=queue{pos}; t=words{pos}; pos=pos+1;
    if numel(b)==1
        if abs(b-24)<1e-9, s=t{1}; break, end
        continue
    end
    for i=1:numel(b)-1
        for j=i+1:numel(b)
            use=true(size(b)); use([i,j])=false;
            val=[b(i)+b(j),b(i)-b(j),b(j)-b(i),b(i)*b(j)];
            e={['(' t{i} '+' t{j} ')'],['(' t{i} '-' t{j} ')'],['(' t{j} '-' t{i} ')'],['(' t{i} '*' t{j} ')']};
            if abs(b(j))>1e-12, val(end+1)=b(i)/b(j); e{end+1}=['(' t{i} '/' t{j} ')']; end
            if abs(b(i))>1e-12, val(end+1)=b(j)/b(i); e{end+1}=['(' t{j} '/' t{i} ')']; end
            for k=1:numel(val)
                queue{end+1}=[b(use),val(k)]; words{end+1}=[t(use),e(k)];
            end
        end
    end
end
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
