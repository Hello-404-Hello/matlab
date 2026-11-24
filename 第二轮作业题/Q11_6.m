a=linspace(0,2*pi,81);
b=[2.06,2.08,.76,.53,.53,.63,.48,.48,.64,1.90,1.88,0,0];
h=[0,.10,2.55,2.9,4.5,4.60,4.60,2.91,2.52,.18,.12,.12,0];
f=linspace(1,numel(h),170);
z=interp1(1:numel(h),h,f,'pchip')';
r=interp1(1:numel(b),b,f,'pchip')';
figure('Color','w')
s=surface(r*cos(a),r*sin(a),z+zeros(size(a)));
s.EdgeColor='none';
s.FaceColor='interp';
s.FaceAlpha=.56;
axis equal off
view(30,23)
camlight
material shiny
