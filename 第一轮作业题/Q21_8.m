a=randi([1,10],1,4);
disp(a)
zhi=cell(1,15); shi=cell(1,15);
for mask=1:15
    weizhi=find(bitget(mask,1:4));
    if numel(weizhi)==1
        zhi{mask}=a(weizhi); shi{mask}={num2str(a(weizhi))};
        continue
    end
    for left=mask-1:-1:1
        if bitand(left,mask)~=left, continue, end
        right=bitxor(mask,left);
        if left>right, continue, end
        for i=1:numel(zhi{left})
            for j=1:numel(zhi{right})
                x=zhi{left}(i); y=zhi{right}(j);
                u=shi{left}{i}; v=shi{right}{j};
                b=[x+y,x-y,y-x,x*y];
                t={['(' u '+' v ')'],['(' u '-' v ')'],['(' v '-' u ')'],['(' u '*' v ')']};
                if abs(y)>1e-12, b(end+1)=x/y; t{end+1}=['(' u '/' v ')']; end
                if abs(x)>1e-12, b(end+1)=y/x; t{end+1}=['(' v '/' u ')']; end
                for k=1:numel(b)
                    if ~any(abs(zhi{mask}-b(k))<1e-10)
                        zhi{mask}(end+1)=b(k); shi{mask}{end+1}=t{k};
                    end
                end
            end
        end
    end
end
k=find(abs(zhi{15}-24)<1e-9,1);
s='';
if ~isempty(k), s=shi{15}{k}; end
if isempty(s)
    disp('无解')
else
    fprintf('%s=24\n',s);
end
