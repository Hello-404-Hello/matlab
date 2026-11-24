a=readmatrix('Temp2.xlsx');
n=length(a);
a0=a-mean(a);
L=2^nextpow2(2*n-1);
p=fft(a0,L);
s=real(ifft(conj(p(:,1)).*p(:,2)));
ii=[L-49:L,1:51];
[~,j]=max(s(ii));
k=j-51;
fprintf('upstream %d, delay %.3f s, speed %.4f m/s\n',1+(k<0),abs(k)/100,5/abs(k))
figure
tt=(0:n-1)*.01;
plot(tt,a(:,1),'k-',tt,a(:,2),'b--')
legend('1','2','Location','best')
xlabel('t (s)')
