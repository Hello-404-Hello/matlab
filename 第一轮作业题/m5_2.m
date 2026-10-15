%%直接写出八个方向上的元素,中心不计入
clearvars
M=randi(20,5,5);
north=M(2,3)+M(1,3);
northeast=M(2,4)+M(1,5);
east=M(3,4)+M(3,5);
southeast=M(4,4)+M(5,5);
south=M(4,3)+M(5,3);
southwest=M(4,2)+M(5,1);
west=M(3,2)+M(3,1);
northwest=M(2,2)+M(1,1);
%输出顺序为12点起顺时针;每个方向是从中心向外的半射线。
totals=[north,northeast,east,southeast,south,southwest,west,northwest];
disp(M)
disp(totals)

