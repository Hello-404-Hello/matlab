rng(13,'twister')
g=randi([0,100],60,3,3);
a=g(:,:,1);
[z,id]=sort(sum(a,2),'descend');
r=cummax((1:60)'.*[true;diff(z)~=0]);
tab=array2table([r,id,a(id,:),z],'VariableNames',{'Rank','ID','S1','S2','S3','Total'});
disp(tab)
disp(array2table([mean(a);var(a,0,1);sum(a>=85)],'VariableNames',{'S1','S2','S3'},'RowNames',{'Mean','Variance','Excellent'}))
b=reshape(mean(sum(g,2),1),1,3);
disp(array2table(b,'VariableNames',{'Class1','Class2','Class3'},'RowNames',{'MeanTotal'}))
fprintf('最优班级')
fprintf(' %d',find(b==max(b)))
fprintf('\n')
