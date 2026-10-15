% 直接用fminsearch最小化加权距离，随后利用凸性条件认证并校正尖点。
% 住宅区序号依次是锦绣华城、丽景家园、悦湖公馆、响水湾小区。
% 公园只排除给定点(6,4)。
% 输出：理论最优坐标；最小加权距离；四候选点的总距离；
% [最优候选序号,x,y,总距离]。
points=[1,3;5,7;8,2;4,5];
people=[1200;2800;1600;3400];
cost=@(z)sum(people.*sqrt((points(:,1)-z(1)).^2+(points(:,2)-z(2)).^2));
initial=(people'*points)/sum(people);
setting=optimset('Display','off','TolX',1e-11,'TolFun',1e-9,...
    'MaxIter',3000,'MaxFunEvals',10000);
position=fminsearch(cost,initial,setting);
% 距离函数在住宅区坐标处不可微，直接核对次梯度可给出全局证明。
for i=1:4
    rest=setdiff(1:4,i);
    dx=points(i,1)-points(rest,1);
    dy=points(i,2)-points(rest,2);
    radius=sqrt(dx.^2+dy.^2);
    gx=sum(people(rest).*dx./radius);
    gy=sum(people(rest).*dy./radius);
    if hypot(gx,gy)<=people(i)
        position=points(i,:);
        break
    end
end
four=zeros(1,4);
for k=1:4
    four(k)=cost(points(k,:));
    if isequal(points(k,:),[6,4])
        four(k)=inf;
    end
end
[distance,id]=min(four);
fprintf('%.6f %.6f\n',position);
fprintf('%.6f\n',cost(position));
fprintf('%.6f %.6f %.6f %.6f\n',four);
fprintf('%d %.6f %.6f %.6f\n',id,points(id,1),points(id,2),distance);
