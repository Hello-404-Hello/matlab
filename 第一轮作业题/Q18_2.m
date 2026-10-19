points=[1,3;5,7;8,2;4,5];
people=[1200;2800;1600;3400];
cost=@(z)sum(people.*sqrt((points(:,1)-z(1)).^2+(points(:,2)-z(2)).^2));
initial=(people'*points)/sum(people);
setting=optimset('Display','off','TolX',1e-11,'TolFun',1e-9,...
    'MaxIter',3000,'MaxFunEvals',10000);
position=fminsearch(cost,initial,setting);
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
