a=randi([1,10],1,4);
disp(a)
val=cell(1,15); expr=cell(1,15);
for mask=1:15
    ids=find(bitget(mask,1:4));
    if numel(ids)==1
        val{mask}=a(ids); expr{mask}={num2str(a(ids))};
        continue
    end
    for left=1:mask-1
        if bitand(left,mask)~=left, continue, end
        right=bitxor(mask,left);
        if left>right, continue, end
        for i=1:numel(val{left})
            for j=1:numel(val{right})
                x=val{left}(i); y=val{right}(j);
                u=expr{left}{i}; v=expr{right}{j};
                b=[x+y,x-y,y-x,x*y];
                t={['(' u '+' v ')'],['(' u '-' v ')'],['(' v '-' u ')'],['(' u '*' v ')']};
                if abs(y)>1e-12, b(end+1)=x/y; t{end+1}=['(' u '/' v ')']; end
                if abs(x)>1e-12, b(end+1)=y/x; t{end+1}=['(' v '/' u ')']; end
                for k=1:numel(b)
                    if ~any(abs(val{mask}-b(k))<1e-10)
                        val{mask}(end+1)=b(k); expr{mask}{end+1}=t{k};
                    end
                end
            end
        end
    end
end
k=find(abs(val{15}-24)<1e-9,1);
s='';
if ~isempty(k), s=expr{15}{k}; end
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
