%%从12点方向开始,依次累加八条射线上的数
clear
A=randi([0,9],5,5);
%不计中心(3,3);每条射线只包含距离中心1格和2格的两个元素。
direction=[-1,0;-1,1;0,1;1,1;1,0;1,-1;0,-1;-1,-1];
s=zeros(1,8);
for k=1:8
    for d=1:2
        row=3+d*direction(k,1);
        col=3+d*direction(k,2);
        s(k)=s(k)+A(row,col);
    end
end
disp(A)
disp(s)

