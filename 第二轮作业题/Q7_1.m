f=@(p)exp(2*p(1))*(p(1)+p(2)^2+2*p(2));
[p,z]=fminsearch(f,[.6,-.9],optimset('TolX',1e-10,'TolFun',1e-12));
disp([p,z])
