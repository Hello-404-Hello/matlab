r=5;
f=@(u)2*pi*u.*sqrt(r^2-u.^2);
x=linspace(0,r,10001);
v=trapz(x,f(x));
syms s
b=int(2*sym(pi)*s*sqrt(r^2-s^2),s,0,r);
fprintf('%.10f  %.10f\n',v,double(b))
disp(abs(v-double(b)))
