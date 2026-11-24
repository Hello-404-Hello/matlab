a=5; n=100;
h=a/n;
u=h/2:h:a-h/2;
num=0;
for k=1:n
    area=pi*(a^2-u(k)^2);
    num=num+area*h;
end
syms x
exact=int(sym(pi)*(25-x^2),x,0,5);
disp([num,double(exact),num-double(exact)])
