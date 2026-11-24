syms x y real
z=exp(2*x)*(x+y^2+2*y);
[u,v]=solve([diff(z,x)==0,diff(z,y)==0],[x,y]);
h=subs(hessian(z,[x,y]),[x,y],[u,v]);
disp([u,v,subs(z,[x,y],[u,v])])
disp(eig(double(h))')
