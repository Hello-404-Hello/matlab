img=imread('ps.jpg');
g=im2double(rgb2gray(img));
bg=imclose(g,strel('disk',23));
d=1-g./max(bg,.01);
b=imopen(d>.34,strel('disk',2));
s=regionprops(b,'Area','MajorAxisLength','PixelIdxList');
remove=false(size(b));
cnt=0;
for j=1:length(s)
    if s(j).Area>=38&&s(j).MajorAxisLength<35
        remove(s(j).PixelIdxList)=true;
        cnt=cnt+1;
    end
end
result=clean(img,imdilate(imfill(remove,'holes'),strel('disk',4)));
figure; imshow(result)
title(sprintf('移除 %d 个红豆',cnt))
disp(cnt)

function out=clean(im,m)
out=im;
for c=1:3
    out(:,:,c)=regionfill(im(:,:,c),m);
end
end
