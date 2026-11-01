a=randi([1,10],1,4);
disp(a)
s=suan(a,arrayfun(@num2str,a,'UniformOutput',false));
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
function s=suan(a,t)
s='';
if numel(a)==1
    if abs(a-24)<1e-9
        s=t{1};
    end
    return
end
for i=1:numel(a)-1
    for j=i+1:numel(a)
        keep=true(size(a)); keep([i,j])=false;
        b=a(keep); u=t(keep);
        val=[a(i)+a(j),a(i)-a(j),a(j)-a(i),a(i)*a(j)];
        expr={['(' t{i} '+' t{j} ')'],['(' t{i} '-' t{j} ')'],['(' t{j} '-' t{i} ')'],['(' t{i} '*' t{j} ')']};
        if abs(a(j))>1e-12
            val(end+1)=a(i)/a(j); expr{end+1}=['(' t{i} '/' t{j} ')'];
        end
        if abs(a(i))>1e-12
            val(end+1)=a(j)/a(i); expr{end+1}=['(' t{j} '/' t{i} ')'];
        end
        for k=1:numel(val)
            s=suan([b,val(k)],[u,expr(k)]);
            if ~isempty(s)
                return
            end
        end
    end
end
end
