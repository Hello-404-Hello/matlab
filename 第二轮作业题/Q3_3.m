rng(13,'twister')
s=reshape(permute(randi([0,100],60,3,3),[1,3,2]),180,3);
k=repelem((1:3)',60);
a=s(k==1,:);
z=sum(a,2);
h=accumarray(z+1,1,[301,1]);
up=flipud(cumsum(flipud(h)))-h;
r=up(z+1)+1;
grade=sortrows([r,(1:60)',a,z],[1,2]);
disp('名次 学号 科1 科2 科3 总分')
disp(grade)
disp('每列依次为平均分、样本方差、优秀人数')
disp([mean(a);std(a).^2;sum(a>=85)])
n=accumarray(k,sum(s>=85,2),[3,1]);
disp(table((1:3)',n,100*n/180,'VariableNames',{'Class','ExcellentEntries','Percent'}))
disp('优秀科次占比最高的班级')
disp(find(n==max(n))')
