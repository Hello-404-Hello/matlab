%%用逻辑与得到点乘结果,矩阵乘法按列累加
clearvars;
left=floor(2*rand(11,11));
right=floor(2*rand(11,11));
elementwise=double(logical(left)&logical(right));
product=zeros(11,11);
for column=1:11
    product(:,column)=sum(left.*repmat(right(:,column).',11,1),2);
end
figure('Color','w');
ax1=subplot(1,2,1);
imshow(elementwise,[],'Parent',ax1);
title(ax1,'A.*B');
ax2=subplot(1,2,2);
imshow(product,[],'Parent',ax2);
title(ax2,'A*B');

