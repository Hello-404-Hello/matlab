p=[1,3;5,7;8,2;4,5];
w=[1200;2800;1600;3400];
park=[6,4];
x=sum(bsxfun(@times,p,w),1)/sum(w);
for iteration=1:10000
    d=sqrt(sum(bsxfun(@minus,p,x).^2,2));
    near=find(d<1e-10,1);
    if isempty(near)
        a=w./d;
        next=sum(bsxfun(@times,p,a),1)/sum(a);
    else
        x=p(near,:);
        use=true(4,1);
        use(near)=false;
        delta=bsxfun(@minus,p(use,:),x);
        dist=sqrt(sum(delta.^2,2));
        a=w(use)./dist;
        resultant=sum(bsxfun(@times,delta,a),1);
        r=norm(resultant);
        if r<=w(near)
            break
        end
        ordinary=sum(bsxfun(@times,p(use,:),a),1)/sum(a);
        ratio=w(near)/r;
        next=(1-ratio)*ordinary+ratio*x;
    end
    if norm(next-x)<1e-11
        x=next;
        break
    end
    x=next;
end
for j=1:4
    use=(1:4)'~=j;
    delta=bsxfun(@minus,p(j,:),p(use,:));
    d=sqrt(sum(delta.^2,2));
    g=sum(bsxfun(@times,delta,w(use)./d),1);
    if norm(g)<=w(j)
        x=p(j,:);
        break
    end
end
minimum=sum(w.*sqrt(sum(bsxfun(@minus,p,x).^2,2)));
candidate=zeros(4,1);
for j=1:4
    if isequal(p(j,:),park)
        candidate(j)=inf;
    else
        candidate(j)=sum(w.*sqrt(sum(bsxfun(@minus,p,p(j,:)).^2,2)));
    end
end
[best,index]=min(candidate);
fprintf('%.6f %.6f\n',x);
fprintf('%.6f\n',minimum);
fprintf('%.6f %.6f %.6f %.6f\n',candidate);
fprintf('%d %.6f %.6f %.6f\n',index,p(index,1),p(index,2),best);
