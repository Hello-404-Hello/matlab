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
