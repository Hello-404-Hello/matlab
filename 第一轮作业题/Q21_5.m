a=randi([1,10],1,4);
disp(a)
p=unique(perms(a),'rows'); s='';
for i=1:size(p,1)
    [values,words]=split(p(i,:));
    id=find(abs(values-24)<1e-9,1);
    if ~isempty(id), s=words{id}; break, end
end
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
function [v,t]=split(a)
if numel(a)==1
    v=a; t={num2str(a)}; return
end
v=[]; t={};
for k=1:numel(a)-1
    [x,u]=split(a(1:k)); [y,w]=split(a(k+1:end));
    for i=1:numel(x)
        for j=1:numel(y)
            b=[x(i)+y(j),x(i)-y(j),x(i)*y(j)];
            c={['(' u{i} '+' w{j} ')'],['(' u{i} '-' w{j} ')'],['(' u{i} '*' w{j} ')']};
            if abs(y(j))>1e-12, b(end+1)=x(i)/y(j); c{end+1}=['(' u{i} '/' w{j} ')']; end
            v=[v,b]; t=[t,c];
        end
    end
end
end
