pic=imread('ps.jpg');
a=im2double(pic(:,:,2));
d=imclose(a,strel('disk',29));
mask=imopen(a<.64*d,strel('disk',2));
s=regionprops(mask,'PixelIdxList','MajorAxisLength','Area');
bean=false(size(a));
n=0;
for i=1:numel(s)
    r=s(i);
    v=r.PixelIdxList;
    if r.Area>=38&&r.MajorAxisLength<35
        bean(v)=true;
        n=n+1;
    end
end
bean=imdilate(imfill(bean,'holes'),strel('disk',3));
y=pic;
for k=1:size(pic,3)
    y(:,:,k)=regionfill(pic(:,:,k),bean);
end
figure
tiledlayout(1,3,'Padding','compact')
nexttile; imshow(pic)
nexttile; imshow(bean)
nexttile; imshow(y)
fprintf('%d\n',n)
