points=[1,3;5,7;8,2;4,5];
weights=[1200;2800;1600;3400];
position=(weights'*points)/sum(weights);
for epsilon=[1,0.1,0.01,0.001,0.0001,0.00001]
    for iteration=1:60
        [old,g,H]=smoothDistance(position,points,weights,epsilon);
        if norm(g)<1e-8
            break
        end
        direction=-(H\g)';
        step=1;
        accepted=false;
        for attempt=1:50
            trial=position+step*direction;
            value=smoothDistance(trial,points,weights,epsilon);
            if value<=old+1e-4*step*(g'*direction')
                accepted=true;
                break
            end
            step=step/2;
        end
        if(~accepted)
            break
        end
        position=trial;
        if norm(step*direction)<1e-11
            break
        end
    end
end
for i=1:4
    force=[0,0];
    for j=1:4
        if j~=i
            delta=points(i,:)-points(j,:);
            force=force+weights(j)*delta/norm(delta);
        end
    end
    if norm(force)<=weights(i)&&~isequal(points(i,:),[6,4])
        position=points(i,:);
        break
    end
end
minimum=sum(weights.*sqrt(sum(bsxfun(@minus,points,position).^2,2)));
candidate=zeros(4,1);
for i=1:4
    candidate(i)=sum(weights.*sqrt(sum(bsxfun(@minus,points,points(i,:)).^2,2)));
    if isequal(points(i,:),[6,4])
        candidate(i)=inf;
    end
end
[best,id]=min(candidate);
fprintf('%.6f %.6f\n',position);
fprintf('%.6f\n',minimum);
fprintf('%.6f %.6f %.6f %.6f\n',candidate);
fprintf('%d %.6f %.6f %.6f\n',id,points(id,1),points(id,2),best);
function [value,gradient,hessian]=smoothDistance(position,points,weights,epsilon)
delta=bsxfun(@minus,position,points);
radius=sqrt(sum(delta.^2,2)+epsilon^2);
value=sum(weights.*radius);
gradient=sum(bsxfun(@times,delta,weights./radius),1)';
hessian=zeros(2);
for i=1:4
    d=delta(i,:)';
    hessian=hessian+weights(i)*(eye(2)/radius(i)-(d*d')/radius(i)^3);
end
end
