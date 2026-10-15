%%用鞋带公式函数计算轮廓面积
clear
photo=imread('餐盘.jpg');
p=[191,103;1045,102;1073,105;1100,114;1124,128;1142,151;1153,177;1157,211;1160,794;1155,828;1145,854;1125,877;1097,894;1073,902;1037,907;183,907;151,904;125,892;102,874;86,849;78,821;74,792;82,214;87,182;99,153;118,130;143,113;167,106];
reference=[1227,424;1470,424];
%标尺边长10cm,输出面积(cm^2)。
pixelSide=sqrt(sum((reference(1,:)-reference(2,:)).^2));
areaCm2=polygon_size(p)*(10/pixelSide)^2;
disp(areaCm2)
figure
image(photo)
axis image
hold on
plot([p(:,1);p(1,1)],[p(:,2);p(1,2)],'g-','LineWidth',1.4)
title('餐盘面积')

function area=polygon_size(points)
s=0;
count=size(points,1);
for i=1:count
    j=mod(i,count)+1;
    s=s+points(i,1)*points(j,2)-points(j,1)*points(i,2);
end
area=abs(s)/2;
end

