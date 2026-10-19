clearvars;
numbers=1000:-1:1;
k=1:floor((sqrt(8*numel(numbers)+1)-1)/2);
indices=k.*(k+1)/2;
remaining=numbers(indices);
disp(remaining);
disp(numel(remaining));
