rng('shuffle');
N=100;
repeat=100;
answer=false(repeat,1);
for experiment=1:repeat
    open=false(N);
    open(randperm(N*N,6500))=true;
    parent=(1:N*N+2)';
    weight=ones(N*N+2,1);
    upper=N*N+1;
    lower=N*N+2;
    for c=1:N
        for r=1:N
            if(~open(r,c))
                continue
            end
            id=r+(c-1)*N;
            nb=[];
            if r==1
                nb(end+1)=upper;
            end
            if r==N
                nb(end+1)=lower;
            end
            if r>1&&open(r-1,c)
                nb(end+1)=id-1;
            end
            if c>1&&open(r,c-1)
                nb(end+1)=id-N;
            end
            for k=1:numel(nb)
                x=id;
                y=nb(k);
                while parent(x)~=x
                    parent(x)=parent(parent(x));
                    x=parent(x);
                end
                while parent(y)~=y
                    parent(y)=parent(parent(y));
                    y=parent(y);
                end
                if x~=y
                    if weight(x)<weight(y)
                        temp=x;
                        x=y;
                        y=temp;
                    end
                    parent(y)=x;
                    weight(x)=weight(x)+weight(y);
                end
            end
        end
    end
    x=upper;
    y=lower;
    while parent(x)~=x
        x=parent(x);
    end
    while parent(y)~=y
        y=parent(y);
    end
    answer(experiment)=x==y;
    if experiment==1
        firstGrid=open;
    end
end
disp(double(answer(1)))
disp(mean(answer))
figure;
imagesc(firstGrid);
axis image;
colormap(gray);
