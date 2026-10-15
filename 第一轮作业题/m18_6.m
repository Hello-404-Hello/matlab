% 把Weiszfeld更新展开为标量循环，再用次梯度确定住宅区点处的最优解。
% 公园只排除点(6,4)。
% 输出最优坐标、总距离、四候选总距离、[候选序号,x,y,总距离]。
xx=[1,5,8,4];
yy=[3,7,2,5];
w=[1200,2800,1600,3400];
x=sum(w.*xx)/sum(w);
y=sum(w.*yy)/sum(w);
for k=1:3000
    numeratorX=0;
    numeratorY=0;
    denominator=0;
    atPoint=0;
    for j=1:4
        d=sqrt((x-xx(j))^2+(y-yy(j))^2);
        if d<1e-12
            atPoint=j;
            break
        end
        numeratorX=numeratorX+w(j)*xx(j)/d;
        numeratorY=numeratorY+w(j)*yy(j)/d;
        denominator=denominator+w(j)/d;
    end
    if atPoint>0
        x=xx(atPoint);
        y=yy(atPoint);
        break
    end
    xnew=numeratorX/denominator;
    ynew=numeratorY/denominator;
    difference=hypot(xnew-x,ynew-y);
    x=xnew;
    y=ynew;
    if difference<1e-11
        break
    end
end
for i=1:4
    gx=0;
    gy=0;
    for j=1:4
        if i~=j
            d=hypot(xx(i)-xx(j),yy(i)-yy(j));
            gx=gx+w(j)*(xx(i)-xx(j))/d;
            gy=gy+w(j)*(yy(i)-yy(j))/d;
        end
    end
    if hypot(gx,gy)<=w(i)
        x=xx(i);
        y=yy(i);
    end
end
minimum=0;
candidate=zeros(1,4);
for j=1:4
    minimum=minimum+w(j)*hypot(x-xx(j),y-yy(j));
    for i=1:4
        candidate(i)=candidate(i)+w(j)*hypot(xx(i)-xx(j),yy(i)-yy(j));
    end
end
[best,id]=min(candidate);
fprintf('%.6f %.6f\n',x,y);
fprintf('%.6f\n',minimum);
fprintf('%.6f %.6f %.6f %.6f\n',candidate);
fprintf('%d %.6f %.6f %.6f\n',id,xx(id),yy(id),best);
