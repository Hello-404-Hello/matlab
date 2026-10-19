clearvars;
img=imread('餐盘.jpg');
tray=select_region(img,[1,1200,1,1024],1);
card=select_region(img,[1200,1500,380,675],2);
areaCm2=100*sum(tray(:))/sum(card(:));
disp(areaCm2);
figure;
image(img);
axis image;
hold on;
contour(tray,[0.5,0.5],'g');
contour(card,[0.5,0.5],'r');
title('餐盘面积');

function mask=select_region(img,box,type)
rgb=double(img);
if type==1
    mask=min(rgb,[],3)>150&(max(rgb,[],3)-min(rgb,[],3))<45;
else
    mask=max(rgb,[],3)<70;
end
region=false(size(mask));
region(box(3):box(4),box(1):box(2))=true;
mask=imfill(mask&region,'holes');
parts=bwconncomp(mask,4);
sizes=cellfun(@numel,parts.PixelIdxList);
[~,which]=max(sizes);
mask(:)=false;
mask(parts.PixelIdxList{which})=true;
end
