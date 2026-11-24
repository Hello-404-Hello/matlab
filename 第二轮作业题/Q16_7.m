a=imread('ps.jpg');
g=im2double(rgb2gray(a));
b=imclose(g,strel('disk',29));
p=imopen(g<.66*b,strel('disk',2));
q=bwpropfilt(p,'Area',[38,inf]);
q=bwpropfilt(q,'MajorAxisLength',[0,34.9999]);
cc=bwconncomp(q);
n=cc.NumObjects;
m=imdilate(imfill(q,'holes'),strel('disk',4));
z=a;
for k=1:3
    z(:,:,k)=patching(z(:,:,k),m);
end
disp(n)
figure
tiledlayout(1,2)
nexttile; imshow(m)
nexttile; imshow(z)

function y=patching(x,b)
f=regionfill(im2double(x),b);
v=imgaussfilt(f,1.1);
y=x;
y(b)=im2uint8(v(b));
end
