%%将四角标定封装为函数,同时显示像素轮廓和厘米轮廓
clear
photo=imread('餐盘.jpg');
corners=[1227,424;1470,424;1472,666;1228,667];
outline=[191,103;1045,102;1073,105;1100,114;1124,128;1142,151;1153,177;1157,211;1160,794;1155,828;1145,854;1125,877;1097,894;1073,902;1037,907;183,907;151,904;125,892;102,874;86,849;78,821;74,792;82,214;87,182;99,153;118,130;143,113;167,106];
%参考矩形宽、高均为10cm。
realPoints=rectify_outline(outline,corners,[10,10]);
next=[2:size(realPoints,1),1];
areaCm2=abs(sum(realPoints(:,1).*realPoints(next,2)-realPoints(:,2).*realPoints(next,1)))/2;
disp(areaCm2)
figure
subplot(1,2,1)
image(photo)
axis image
hold on
plot([outline(:,1);outline(1,1)],[outline(:,2);outline(1,2)],'r')
title('餐盘轮廓')
subplot(1,2,2)
fill(realPoints(:,1),realPoints(:,2),[0.8,0.9,1])
axis equal
xlabel('cm')
ylabel('cm')
title('餐盘面积')

function points=rectify_outline(outline,corners,side)
target=[0,0;side(1),0;side(1),side(2);0,side(2)];
A=zeros(8,8);
b=zeros(8,1);
for i=1:4
    u=corners(i,1);
    v=corners(i,2);
    x=target(i,1);
    y=target(i,2);
    A(2*i-1,:)=[u,v,1,0,0,0,-x*u,-x*v];
    A(2*i,:)=[0,0,0,u,v,1,-y*u,-y*v];
    b(2*i-1)=x;
    b(2*i)=y;
end
c=A\b;
H=[c(1:3).';c(4:6).';c(7:8).',1];
mapped=H*[outline.';ones(1,size(outline,1))];
points=[(mapped(1,:)./mapped(3,:)).',(mapped(2,:)./mapped(3,:)).'];
end
