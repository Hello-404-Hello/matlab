r=5;
x=integral(@(z)pi*(r^2-z.^2),0,r);
syms t
y=int(sym(pi)*(r^2-t^2),t,0,r);
disp(x)
disp(y)
disp(abs(x-double(y)))
