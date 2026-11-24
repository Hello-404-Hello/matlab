file='Temp2.xlsx';
opts=detectImportOptions(file);
tab=readtable(file,opts);
x=table2array(tab);
n=size(x,1);
r=zeros(101,1);
for j=1:101
    k=j-51;
    id=max(1,1-k):min(n,n-k);
    a=rankvalue(x(id,1)); b=rankvalue(x(id+k,2));
    c=corrcoef(a,b);
    r(j)=c(1,2);
end
[~,p]=max(r);
k=p-51;
fprintf('%d %.2f %.3f\n',1+(k<0),k/100,5/abs(k))
figure
stairs((0:n-1)*.01,x)
legend('1','2')
xlabel('s')
grid on

function r=rankvalue(x)
[~,~,a]=unique(x,'sorted');
f=accumarray(a,1);
rank=cumsum(f)-(f-1)/2;
r=rank(a);
end
