rng(15,'twister')
a=rand(50)>=.5;
p=false(58); p(5:54,5:54)=logical(a);
dirs=[1,0;0,1;1,1;1,-1];
hits=cell(4,1);
n=0;
for i=1:4
    m=true(50);
    for j=0:4
        x=(5:54)+j*dirs(i,1);
        y=(5:54)+j*dirs(i,2);
        m=m&p(x,y);
    end
    [r,c]=find(m);
    hits{i}=[r,c];
    n=n+nnz(m);
end
disp(n)
figure
imagesc(a)
axis image
colormap(gray)
hold on
for j=1:4
    p=hits{j};
    line([p(:,2),p(:,2)+4*dirs(j,2)]',[p(:,1),p(:,1)+4*dirs(j,1)]','Color','r')
end
