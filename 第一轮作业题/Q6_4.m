clearvars;
photo=imread('餐盘.jpg');
rgb=double(photo);
light=min(rgb,[],3);
colorRange=max(rgb,[],3)-light;
white=light>150&colorRange<45;
white(:,1201:end)=false;
[nr,nc]=size(white);
edgePoints=zeros(2*nr,2);
used=0;
for row=1:nr
    columns=find(white(row,:));
    if(~isempty(columns))
        edgePoints(used+1,:)=[columns(1),row];
        edgePoints(used+2,:)=[columns(end),row];
        used=used+2;
    end
end
edgePoints=edgePoints(1:used,:);
hull=convhull(edgePoints(:,1),edgePoints(:,2));
x=edgePoints(hull,1);
y=edgePoints(hull,2);
dark=max(rgb,[],3)<70;
cardMask=false(nr,nc);
cardMask(380:675,1200:1500)=dark(380:675,1200:1500);
[cardY,cardX]=find(cardMask);
pixelSide=mean([max(cardX)-min(cardX)+1,max(cardY)-min(cardY)+1]);
realSide=10;
areaCm2=polyarea(x,y)*(realSide/pixelSide)^2;
disp(areaCm2);
figure;
image(photo);
axis image;
hold on;
plot(x,y);
title('餐盘面积');
