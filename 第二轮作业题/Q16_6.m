pic=imread('ps.jpg');
g=im2double(rgb2gray(pic));
white=imclose(g,strel('disk',18));
dark=imopen(1-g./max(white,.01)>.27,strel('disk',2));
cc=bwconncomp(dark);
f=regionprops(cc,'Area','MajorAxisLength');
keep=find([f.Area]>=38&[f.MajorAxisLength]<35);
mark=false(size(g));
for j=keep
    mark(cc.PixelIdxList{j})=1;
end
mark=imfill(mark,'holes');
edge=imdilate(mark,strel('disk',3));
mask=edge&((white-g)>.018|mark);
mask=imfill(mask,'holes');
dst=pic;
for j=1:3
    dst(:,:,j)=regionfill(pic(:,:,j),mask);
end
disp(numel(keep))
figure
imshowpair(pic,dst,'montage')
