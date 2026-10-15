%%每行打印一个方向的和,共八行
clear
a=randi([1,50],5,5);
answer=zeros(8,1);
%不含中心。顺序为上、右上、右、右下、下、左下、左、左上。
answer(1)=sum(a(1:2,3));
answer(2)=a(1,5)+a(2,4);
answer(3)=sum(a(3,4:5));
answer(4)=a(4,4)+a(5,5);
answer(5)=sum(a(4:5,3));
answer(6)=a(4,2)+a(5,1);
answer(7)=sum(a(3,1:2));
answer(8)=a(1,1)+a(2,2);
%矩阵保留在工作区变量a中;命令窗口只输出八个方向各自的和。
for i=1:8
    fprintf('%g\n',answer(i));
end

