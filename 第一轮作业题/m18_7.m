% 距离矩阵一次算出四个候选点费用，用次梯度条件求理论最优点。
% 公园只排除点(6,4)。图中圆大小表示人口，红星表示选址。
% 输出最优坐标、总距离、四候选总距离、[候选序号,x,y,总距离]。
p=[1,3;5,7;8,2;4,5];
w=[1200;2800;1600;3400];
dx=p(:,1)-p(:,1)';
dy=p(:,2)-p(:,2)';
D=hypot(dx,dy);
candidate=D*w;
ratio=zeros(4);
for i=1:4
    for j=1:4
        if i~=j
            ratio(i,j)=w(j)/D(i,j);
        end
    end
end
gx=sum(ratio.*dx,2);
gy=sum(ratio.*dy,2);
theory=find(gx.^2+gy.^2<=w.^2,1);
position=p(theory,:);
minimum=candidate(theory);
[best,id]=min(candidate);
fprintf('%.6f %.6f\n',position);
fprintf('%.6f\n',minimum);
fprintf('%.6f %.6f %.6f %.6f\n',candidate);
fprintf('%d %.6f %.6f %.6f\n',id,p(id,1),p(id,2),best);
figure;
scatter(p(:,1),p(:,2),w/12,'b','filled');
hold on;
for i=1:4
    plot([position(1),p(i,1)],[position(2),p(i,2)],'k--');
end
plot(position(1),position(2),'r*','MarkerSize',15,'LineWidth',2);
axis equal;
grid on;
hold off;
