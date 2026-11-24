r=sym(5);
syms rho theta phi
formula=int(int(int(rho^2*sin(phi),rho,0,r),phi,0,sym(pi)/2),theta,0,2*sym(pi));
v=integral3(@(a,b,c)a.^2.*sin(c),0,5,0,2*pi,0,pi/2);
disp(formula)
fprintf('%.12f\n%.3g\n',v,abs(v-double(formula)))
