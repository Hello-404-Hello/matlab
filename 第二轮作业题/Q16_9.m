a=imread('ps.jpg');
green=im2double(a(:,:,2));
grey=im2double(rgb2gray(a));
p=imopen(green<.70*imclose(green,strel('disk',18)),strel('disk',2));
q=imopen(grey<.66*imclose(grey,strel('disk',23)),strel('disk',2));
cc=regionprops(p,'PixelIdxList','Area','MajorAxisLength');
mask=false(size(green));
n=0;
for j=1:numel(cc)
    s=cc(j);
    if s.Area>=38&&s.MajorAxisLength<35&&mean(q(s.PixelIdxList))>.5
        mask(s.PixelIdxList)=true;
        n=n+1;
    end
end
m=imdilate(imfill(mask,'holes'),strel('disk',3));
img=a;
for j=3:-1:1
    img(:,:,j)=regionfill(a(:,:,j),m);
end
disp(n)
figure
imshow(img)
title('绿色通道与灰度联合检测')
