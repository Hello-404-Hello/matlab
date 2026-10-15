%%逐行扫描餐盘左右边缘,累加每行像素数
clearvars
photo=imread('餐盘.jpg');
data=double(photo);
trayPixels=0;
left=[];
right=[];
rows=[];
for row=1:size(data,1)
    first=0;
    last=0;
    for column=1:1200
        pixel=data(row,column,:);
        if min(pixel)>150&&max(pixel)-min(pixel)<45
            if first==0
                first=column;
            end
            last=column;
        end
    end
    if first>0
        trayPixels=trayPixels+last-first+1;
        left(end+1)=first;
        right(end+1)=last;
        rows(end+1)=row;
    end
end
cardPixels=0;
for row=380:675
    for column=1200:1500
        if max(data(row,column,:))<70
            cardPixels=cardPixels+1;
        end
    end
end
%黑色参考物面积100cm^2,按像素面积比例换算。
areaCm2=100*trayPixels/cardPixels;
disp(areaCm2)
figure
image(photo)
axis image
hold on
plot([left,fliplr(right),left(1)],[rows,fliplr(rows),rows(1)],'m-')
title('餐盘面积')

