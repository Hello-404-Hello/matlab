queen=[4,6];
horse=[5,4];
king=[5,8];
can_take_queen=false;
steps=[1,2;1,-2;-1,2;-1,-2;2,1;2,-1;-2,1;-2,-1];
d=-ones(8);
d(horse(1),horse(2))=0;
queue=zeros(64,2);
queue(1,:)=horse;
a=1;
b=1;
while a<=b
    p=queue(a,:);
    a=a+1;
    if isequal(p,king)
        break
    end
    for j=1:8
        q=p+steps(j,:);
        if any(q<1|q>8)||(~can_take_queen&&isequal(q,queen))
            continue
        end
        if d(q(1),q(2))==-1
            d(q(1),q(2))=d(p(1),p(2))+1;
            b=b+1;
            queue(b,:)=q;
        end
    end
end
disp(d(king(1),king(2)))
