a=imread('ps.jpg');
green=im2double(a(:,:,2));
bg=imclose(green,strel('disk',23));
raw=imopen(1-green./max(bg,.01)>.34,strel('disk',2));
p=regionprops(raw,'Area','MajorAxisLength','Solidity','PixelIdxList');
[~,k]=sort([p.Area],'descend');
m=false(size(raw)); n=0;
for i=k
    if p(i).Area>=38&&p(i).MajorAxisLength<35
        m(p(i).PixelIdxList)=true;
        n=n+1;
    end
end
m=imdilate(imfill(m,'holes'),strel('disk',3));
pic=a;
for k=1:3
    pic(:,:,k)=regionfill(a(:,:,k),m);
end
figure('Color','w')
imshowpair(a,pic,'montage')
disp(n)
