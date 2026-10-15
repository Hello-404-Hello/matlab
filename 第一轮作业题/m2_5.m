%%先标出保留位置,再从尾部向前删除其余元素
clear
numbers=1000:-1:1;
positions=cumsum(1:1000);
positions=positions(positions<=1000);
keep=false(1,1000);
keep(positions)=true;
for index=1000:-1:1
    if(~keep(index))
        numbers(index)=[];
    end
end
disp(numbers)
disp(numel(numbers))

