im=imread('ps.jpg');
g=im2double(rgb2gray(im));
b=imclose(g,strel('disk',18));
m=imfill(imopen(g<.7*b,strel('disk',2)),'holes');
p=regionprops(m,'PixelIdxList','MajorAxisLength','Area');
out=false(size(m));
n=0;
for i=1:numel(p)
    if p(i).Area>=38&&p(i).MajorAxisLength<35
        out(p(i).PixelIdxList)=true;
        n=n+1;
    end
end
out=imdilate(out,strel('disk',3));
result=im;
for i=1:3
    x=im(:,:,i);
    result(:,:,i)=regionfill(x,out);
end
figure
subplot(1,2,1); imshow(im); title('原图')
subplot(1,2,2); imshow(result); title('去豆')
disp(n)
