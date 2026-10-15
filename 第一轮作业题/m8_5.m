% 按通解步长列出全部解。
% 输入为大于8的整数，输出每组[3的系数,5的系数]。
n=29;
solutions=allDecompositions(n);
disp(solutions);

function pairs=allDecompositions(n)
firstFive=mod(2*mod(n,3),3);
five=firstFive:3:floor(n/5);
three=(n-5*five)/3;
pairs=[three(:) five(:)];
end
