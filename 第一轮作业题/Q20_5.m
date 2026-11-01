rn=[1.38,1.90;1.24,1.27;1.56,2.08;1.40,1.70;1.38,1.64;1.38,1.82;1.36,1.74;1.48,1.82;1.54,1.82];
ref=[1.18,1.96;1.14,1.82;1.28,2.00;1.20,1.86;1.30,1.96;1.26,2.00];
test=[1.24,1.80;1.28,1.84;1.40,2.04];
x=[rn;ref]; avg=mean(x); sd=std(x);
a=(rn-avg)./sd; b=(ref-avg)./sd; z=(test-avg)./sd;
u=mean(a); v=mean(b);
w=(8*cov(a)+5*cov(b))\(u-v)';
limit=(u+v)*w/2;
label=z*w>=limit;
for i=1:3
    if label(i)==1
        name='Rn';
    else
        name='Ref';
    end
    fprintf('(%.2f, %.2f): %s\n',test(i,1),test(i,2),name);
end
figure; scatter(rn(:,1),rn(:,2),60,'b','filled'); hold on
scatter(ref(:,1),ref(:,2),60,'r','filled');
scatter(test(:,1),test(:,2),90,'k','x');
text(test(:,1)+0.005,test(:,2),{'1','2','3'});
xlabel('身长'); ylabel('翅形'); legend('Rn','Ref','待分类标本'); grid on
