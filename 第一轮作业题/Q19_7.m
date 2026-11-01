names={'A1.png','A2.png'};
result=[];
for k=1:2
    a=imread(names{k});
    b=im2gray(a)<80;
    x=sum(b,1)>5;
    y=sum(b,2)>5;
    c=find(diff([false,x,false])==1);
    d=find(diff([false,x,false])==-1)-1;
    e=find(diff([false;y;false])==1);
    g=find(diff([false;y;false])==-1)-1;
    n=numel(c);
    m=numel(e);
    z=zeros(4096,m*n);
    for i=1:m
        for j=1:n
            p=b(e(i):g(i),c(j):d(j));
            [yy,xx]=find(p);
            p=p(min(yy):max(yy),min(xx):max(xx));
            p=imresize(p,[64,64],'nearest');
            z(:,(i-1)*n+j)=p(:);
        end
    end
    [u,~,~]=svd(z,'econ');
    p=u(:,1)*(u(:,1)'*z);
    score=sum((z-p).^2,1);
    ordered=sort(score,'descend');
    [~,cut]=max(ordered(1:end-1)-ordered(2:end));
    limit=(ordered(cut)+ordered(cut+1))/2;
    ids=find(score>limit);
    figure; imshow(a); hold on
    for id=ids
        row=ceil(id/n); col=mod(id-1,n)+1;
        box=[c(col)-2,e(row)-2,d(col)-c(col)+4,g(row)-e(row)+4];
        result=[result;k,row,col];
        rectangle('Position',box,'EdgeColor','r','LineWidth',2);
        fprintf('%s: 第%d行，第%d列\n',names{k},row,col);
    end
    title(names{k});
end
