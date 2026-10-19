n=29;
solutions=allDecompositions(n);
disp(solutions);

function pairs=allDecompositions(n)
firstFive=mod(2*mod(n,3),3);
five=firstFive:3:floor(n/5);
three=(n-5*five)/3;
pairs=[three(:) five(:)];
end
