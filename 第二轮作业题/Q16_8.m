pic=im2double(imread('ps.jpg'));
g=pic(:,:,2);
flat=imclose(g,strel('disk',23));
dark=imopen(g<.66*flat,strel('disk',2));
s=regionprops(dark,'PixelIdxList','Area','MajorAxisLength');
bean=false(size(g));
n=0;
for i=1:length(s)
    p=s(i);
    if p.Area>=38&&p.MajorAxisLength<35
        bean(p.PixelIdxList)=true;
        n=n+1;
    end
end
inside=imdilate(imfill(bean,'holes'),strel('disk',2));
outside=imdilate(inside,strel('disk',4));
alpha=max(double(inside),min(1,imgaussfilt(double(inside),1.2)*1.35));
alpha(~outside)=0;
out=pic;
for c=1:3
    layer=pic(:,:,c);
    bg=regionfill(layer,outside);
    out(:,:,c)=(1-alpha).*layer+alpha.*bg;
end
disp(n)
figure
subplot(1,2,1); imshow(pic)
subplot(1,2,2); imshow(out)
