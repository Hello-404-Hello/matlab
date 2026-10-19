xy=[1,3;5,7;8,2;4,5];
population=[1200;2800;1600;3400];
total=zeros(4,1);
certificate=zeros(4,2);
theory=0;
for a=1:4
    force=[0,0];
    for b=1:4
        if b==a
            continue
        end
        vector=xy(a,:)-xy(b,:);
        d=norm(vector);
        total(a)=total(a)+population(b)*d;
        force=force+population(b)*vector/d;
    end
    certificate(a,:)=[norm(force),population(a)];
    if norm(force)<=population(a)&&~isequal(xy(a,:),[6,4])
        theory=a;
    end
    if isequal(xy(a,:),[6,4])
        total(a)=inf;
    end
end
[best,k]=min(total);
fprintf('%.6f %.6f\n',xy(theory,:));
fprintf('%.6f\n',total(theory));
fprintf('%.6f %.6f %.6f %.6f\n',total);
fprintf('%d %.6f %.6f %.6f\n',k,xy(k,1),xy(k,2),best);
fprintf('%.6f %d\n',certificate');
