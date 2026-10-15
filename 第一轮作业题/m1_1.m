%%用整数随机数分别完成点乘和矩阵乘法
clear
A=randi([0,1],11,11);
B=randi([0,1],11,11);
C=A.*B;
D=A*B;
figure;
subplot(1,2,1);
imshow(C,[]);
title('A.*B');
subplot(1,2,2);
imshow(D,[]);
title('A*B');

