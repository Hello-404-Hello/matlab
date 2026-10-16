p=[1,3;5,7;8,2;4,5];
w=[1200;2800;1600;3400];
xmin=min(p(:,1));
xmax=max(p(:,1));
ymin=min(p(:,2));
ymax=max(p(:,2));
best=inf;
answer=[0,0];
for step=[0.5,0.1,0.02,0.004]
    for x=xmin:step:xmax
        for y=ymin:step:ymax
            if x==6&&y==4
                continue
            end
            distance=sqrt((p(:,1)-x).^2+(p(:,2)-y).^2);
            total=sum(w.*distance);
            if total<best
                best=total;
                answer=[x,y];
            end
        end
    end
    xmin=max(min(p(:,1)),answer(1)-step);
    xmax=min(max(p(:,1)),answer(1)+step);
    ymin=max(min(p(:,2)),answer(2)-step);
    ymax=min(max(p(:,2)),answer(2)+step);
end
for i=1:4
    g=[0,0];
    for j=1:4
        if j~=i
            v=p(i,:)-p(j,:);
            g=g+w(j)*v/norm(v);
        end
    end
    if norm(g)<=w(i)&&~isequal(p(i,:),[6,4])
        answer=p(i,:);
        best=sum(w.*sqrt(sum(bsxfun(@minus,p,answer).^2,2)));
        break
    end
end
candidate=zeros(4,1);
for i=1:4
    candidate(i)=sum(w.*sqrt(sum(bsxfun(@minus,p,p(i,:)).^2,2)));
    if isequal(p(i,:),[6,4])
        candidate(i)=inf;
    end
end
[score,id]=min(candidate);
fprintf('%.6f %.6f\n',answer);
fprintf('%.6f\n',best);
fprintf('%.6f %.6f %.6f %.6f\n',candidate);
fprintf('%d %.6f %.6f %.6f\n',id,p(id,1),p(id,2),score);
