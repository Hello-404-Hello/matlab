rng('shuffle');
cells=false(100);
cells(randperm(10000,6500))=true;
id=reshape(1:10000,100,100);
vertical=cells(1:99,:)&cells(2:100,:);
horizontal=cells(:,1:99)&cells(:,2:100);
fromDown=id(1:99,:);
toDown=id(2:100,:);
fromRight=id(:,1:99);
toRight=id(:,2:100);
top=10001;
bottom=10002;
topCells=id(1,cells(1,:));
bottomCells=id(100,cells(100,:));
from=[fromDown(vertical);fromRight(horizontal);top*ones(numel(topCells),1);bottom*ones(numel(bottomCells),1)];
to=[toDown(vertical);toRight(horizontal);topCells(:);bottomCells(:)];
network=graph(from,to,[],10002);
path=shortestpath(network,top,bottom);
disp(double(~isempty(path)))
figure;
imagesc(cells);
colormap(gray);
axis image;
if(~isempty(path))
    ordinary=path(path<=10000);
    [r,c]=ind2sub([100,100],ordinary);
    hold on;
    plot(c,r,'m-','LineWidth',2);
    hold off;
end
