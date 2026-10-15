%%已知边长标定:手工轮廓的像素面积换算为平方厘米
clearvars
%标尺边长10cm,输出轮廓面积(cm^2)。
%interactive=true时改为手工点选。
%标尺与餐盘轮廓共面,镜头正摄。
interactive=false;
if interactive
    [file,folder]=uigetfile({'*.jpg;*.jpeg;*.png;*.bmp','照片'});
    photo=imread(fullfile(folder,file));
else
    photo=imread('餐盘.jpg');
end
figure;
image(photo);
axis image;
hold on
if interactive
    title('依次点击标尺上已知长度的两个端点');
    [sx,sy]=ginput(2);
    realLength=input('两端点实际距离(cm):');
else
    sx=[1227;1470];
    sy=[424;424];
    realLength=10;
end
pixelLength=hypot(sx(2)-sx(1),sy(2)-sy(1));
plot(sx,sy,'y-o');
if interactive
    title('按边界顺序点击餐盘轮廓,最后按Enter');
    [x,y]=ginput;
else
    %依次记录餐盘边缘的轮廓点。
    points=[191,103;1045,102;1073,105;1100,114;1124,128;1142,151;1153,177;1157,211;1160,794;1155,828;1145,854;1125,877;1097,894;1073,902;1037,907;183,907;151,904;125,892;102,874;86,849;78,821;74,792;82,214;87,182;99,153;118,130;143,113;167,106];
    x=points(:,1);
    y=points(:,2);
    title('餐盘面积');
end
plot([x;x(1)],[y;y(1)],'r-');
areaCm2=polyarea(x,y)*(realLength/pixelLength)^2;
disp(areaCm2)

