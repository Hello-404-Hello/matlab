m=1400; f=32000; c=.4; g=9.8;
one=@(t,z)[z(2);(f-c*z(2)*abs(z(2)))/(m-18*t)-g];
two=@(~,z)[z(2);-c*z(2)*abs(z(2))/320-g];
p=odeset('RelTol',1e-8,'AbsTol',1e-9);
[x,a]=ode23(one,[0,60],[0,0],p);
[y,b,stop,top]=ode23(two,[60,90],a(end,:),odeset(p,'Events',@finish));
z=one(60,a(end,:));
w=two(60,a(end,:));
disp([a(end,:)';z(2);w(2);stop;top(1)])
t=[x;y];
h=[a(:,1);b(:,1)];
v=[a(:,2);b(:,2)];
aa=[(f-c*a(:,2).^2)./(m-18*x)-g;-g-c*b(:,2).^2/320];
figure
timetable_plot=stackedplot(t,[h,v,aa]);
timetable_plot.DisplayLabels={'高度 (m)','速度 (m/s)','加速度 (m/s²)'};

function [x,s,k]=finish(~,y)
x=y(2);
s=1;
k=-1;
end
