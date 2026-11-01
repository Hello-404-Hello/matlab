names={'A','B','C','D','E','F','G','H','J'};
edge=[1,2,5;1,8,9;2,3,8;2,8,11;3,4,7;3,6,4;3,9,2;4,5,9;4,6,13;5,6,10;6,7,2;7,8,1;7,9,6;8,9,7];
g=graph(edge(:,1),edge(:,2),edge(:,3),names);
t=minspantree(g,'Method','sparse');
[~,a]=ismember(t.Edges.EndNodes(:,1),names);
[~,b]=ismember(t.Edges.EndNodes(:,2),names);
tree=[a,b,t.Edges.Weight];
total=sum(tree(:,3));
for i=1:size(tree,1)
    fprintf('%s-%s: %g\n',names{tree(i,1)},names{tree(i,2)},tree(i,3));
end
fprintf('总长度: %g\n',total);
g=graph(edge(:,1),edge(:,2),edge(:,3),names);
figure; h=plot(g,'EdgeLabel',g.Edges.Weight,'Layout','circle');
highlight(h,tree(:,1),tree(:,2),'EdgeColor','r','LineWidth',2);
title(sprintf('最短管网，总长度 %g',total));
