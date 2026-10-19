clear
A=randi([0,9],5,5);
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
