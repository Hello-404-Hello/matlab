%%先产生均匀随机数,再用阈值得到0和1
clearvars
a=double(rand(11)>0.5);
b=double(rand(11)>0.5);
dotResult=zeros(11);
matrixResult=zeros(11);
for i=1:11
    for j=1:11
        dotResult(i,j)=a(i,j)*b(i,j);
        for k=1:11
            matrixResult(i,j)=matrixResult(i,j)+a(i,k)*b(k,j);
        end
    end
end
figure
subplot(121)
imshow(dotResult,[0,1])
title('A.*B')
subplot(122)
imshow(matrixResult,[0,11])
title('A*B')

