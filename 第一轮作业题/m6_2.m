%%四角投影标定:从像素坐标映射到厘米坐标
clear
%参考正方形边长10cm,输出面积(cm^2)。
%interactive=true时手工点选,参考矩形与轮廓共面。
%四角按顺时针点选,第1至第2角为宽,第2至第3角为高。
interactive=false;
if interactive
    [name,path]=uigetfile({'*.jpg;*.jpeg;*.png;*.bmp','照片'});
    I=imread(fullfile(path,name));
else
    I=imread('餐盘.jpg');
end
figure
image(I)
axis image
hold on
if interactive
    title('顺时针点击矩形四角,先点宽边的两个端点')
    [u,v]=ginput(4);
    width=input('参考矩形宽(cm):');
    height=input('参考矩形高(cm):');
else
    corners=[1227,424;1470,424;1472,666;1228,667];
    u=corners(:,1);
    v=corners(:,2);
    width=10;
    height=10;
end
target=[0,0;width,0;width,height;0,height];
systemMatrix=zeros(8,8);
rhs=zeros(8,1);
for i=1:4
    X=target(i,1);
    Y=target(i,2);
    systemMatrix(2*i-1,:)=[u(i),v(i),1,0,0,0,-X*u(i),-X*v(i)];
    systemMatrix(2*i,:)=[0,0,0,u(i),v(i),1,-Y*u(i),-Y*v(i)];
    rhs(2*i-1:2*i)=[X;Y];
end
coefficients=systemMatrix\rhs;
H=[coefficients(1:3).';coefficients(4:6).';coefficients(7:8).',1];
plot([u;u(1)],[v;v(1)],'y-o')
if interactive
    title('按顺序点击餐盘轮廓,最后按Enter')
    [px,py]=ginput;
else
    points=[191,103;1045,102;1073,105;1100,114;1124,128;1142,151;1153,177;1157,211;1160,794;1155,828;1145,854;1125,877;1097,894;1073,902;1037,907;183,907;151,904;125,892;102,874;86,849;78,821;74,792;82,214;87,182;99,153;118,130;143,113;167,106];
    px=points(:,1);
    py=points(:,2);
    title('餐盘面积')
end
world=H*[px.';py.';ones(1,numel(px))];
worldX=world(1,:)./world(3,:);
worldY=world(2,:)./world(3,:);
plot([px;px(1)],[py;py(1)],'r-')
areaCm2=polyarea(worldX,worldY);
disp(areaCm2)
figure
plot([worldX,worldX(1)],[worldY,worldY(1)],'b-')
axis equal
grid on
xlabel('cm')
ylabel('cm')

