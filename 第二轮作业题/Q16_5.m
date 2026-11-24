a=imread('ps.jpg');
g=im2double(a(:,:,2));
base=imdilate(g,strel('square',29));
b=imopen(g<.28*base,strel('disk',2));
s=regionprops(b,'Area','MajorAxisLength','PixelIdxList');
keep=false(size(g));
for j=1:length(s)
    if s(j).Area>=38&&s(j).MajorAxisLength<35
        keep(s(j).PixelIdxList)=true;
    end
end
cores=bwconncomp(keep);
keep=imdilate(imfill(keep,'holes'),strel('disk',7));
out=im2double(a);
cc=bwconncomp(keep);
[x,y]=meshgrid(1:size(g,2),1:size(g,1));
for j=1:cc.NumObjects
    id=cc.PixelIdxList{j};
    [r,c]=ind2sub(size(g),id);
    i=max(1,min(r)-5):min(size(g,1),max(r)+5);
    k=max(1,min(c)-5):min(size(g,2),max(c)+5);
    xx=x(i,k); yy=y(i,k);
    ok=~keep(i,k);
    fit=[xx(ok),yy(ok),ones(nnz(ok),1)];
    need=[x(id),y(id),ones(numel(id),1)];
    for t=1:3
        z=out(:,:,t);
        box=z(i,k);
        z(id)=min(1,max(0,need*(fit\box(ok))));
        out(:,:,t)=z;
    end
end
figure
imshow(out)
title('红豆区域以局部背景平面填补')
disp(cores.NumObjects)
