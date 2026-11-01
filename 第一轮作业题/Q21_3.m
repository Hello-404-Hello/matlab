a=randi([1,10],1,4);
disp(a)
p=unique(perms(a),'rows');
op='+-*/'; s='';
for i=1:size(p,1)
    t=arrayfun(@num2str,p(i,:),'UniformOutput',false);
    for j=1:64
        k=j-1;
        x=op(mod(k,4)+1); y=op(mod(floor(k/4),4)+1); z=op(floor(k/16)+1);
        e={['(((' t{1} x t{2} ')' y t{3} ')' z t{4} ')'],...
           ['((' t{1} x '(' t{2} y t{3} '))' z t{4} ')'],...
           ['((' t{1} x t{2} ')' y '(' t{3} z t{4} '))'],...
           ['(' t{1} x '((' t{2} y t{3} ')' z t{4} '))'],...
           ['(' t{1} x '(' t{2} y '(' t{3} z t{4} ')))']};
        for k=1:5
            value=eval(e{k});
            if isfinite(value)&&abs(value-24)<1e-9
                s=e{k}; break
            end
        end
        if ~isempty(s), break, end
    end
    if ~isempty(s), break, end
end
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
