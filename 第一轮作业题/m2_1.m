%%从原序列中依次删除1个、2个、3个数
clear
a=1000:-1:1;
pos=1;
removeCount=1;
while pos<numel(a)
    last=min(pos+removeCount,numel(a));
    a(pos+1:last)=[];
    pos=pos+1;
    removeCount=removeCount+1;
end
disp(a)
disp(length(a))

