%%用角度生成八个方向,一次性提取每条射线的元素
clearvars;
matrix=randi([-9,9],5,5);
angles=(0:45:315)*pi/180;
dr=-round(cos(angles));
dc=round(sin(angles));
%0度为12点,角度顺时针增大。只取半径1、2,不计中心。
rows=3+bsxfun(@times,[1;2],dr);
cols=3+bsxfun(@times,[1;2],dc);
locations=sub2ind(size(matrix),rows,cols);
raySums=sum(matrix(locations),1);
disp(matrix);
%以下8个数各自对应一个方向。
disp(raySums);

