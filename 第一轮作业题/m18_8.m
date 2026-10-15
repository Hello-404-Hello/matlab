% 内层对y做一维最小化，外层对x做一维最小化，再计算次梯度。
% 公园只排除点(6,4)。
% 输出最优坐标、总距离、四候选总距离、[候选序号,x,y,总距离]。
points=[1,3;5,7;8,2;4,5];
people=[1200;2800;1600;3400];
options=optimset('Display','off','TolX',1e-10);
x=fminbnd(@(x)verticalCost(x,points,people),1,8,options);
y=fminbnd(@(y)distanceCost([x,y],points,people),2,7,options);
position=[x,y];
for i=1:4
    force=[0,0];
    for j=1:4
        if i~=j
            direction=points(i,:)-points(j,:);
            force=force+people(j)*direction/norm(direction);
        end
    end
    if norm(force)<=people(i)
        position=points(i,:);
        break
    end
end
candidate=zeros(1,4);
for i=1:4
    candidate(i)=distanceCost(points(i,:),points,people);
end
[best,id]=min(candidate);
fprintf('%.6f %.6f\n',position);
fprintf('%.6f\n',distanceCost(position,points,people));
fprintf('%.6f %.6f %.6f %.6f\n',candidate);
fprintf('%d %.6f %.6f %.6f\n',id,points(id,1),points(id,2),best);

function value=verticalCost(x,points,people)
options=optimset('Display','off','TolX',1e-10);
[~,value]=fminbnd(@(y)distanceCost([x,y],points,people),2,7,options);
end

function value=distanceCost(position,points,people)
value=0;
for k=1:4
    dx=position(1)-points(k,1);
    dy=position(2)-points(k,2);
    value=value+people(k)*sqrt(dx^2+dy^2);
end
end
