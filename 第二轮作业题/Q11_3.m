a=[0,0;2,0;2,.12;.66,2.6;.50,2.9;.50,4.5;.67,4.6;.43,4.6;.43,2.9;.55,2.55;1.84,.18;0,.18];
n=56;
theta=(0:n-1)*2*pi/n;
x=a(:,1).*cos(theta); y=a(:,1).*sin(theta);
z=repmat(a(:,2),1,n);
m=size(a,1);
f=[];
for j=1:n
    q=mod(j,n)+1;
    for k=1:m-1
        f(end+1,:)=[k+(j-1)*m,k+1+(j-1)*m,k+1+(q-1)*m,k+(q-1)*m];
    end
end
figure
patch('Vertices',[x(:),y(:),z(:)],'Faces',f,'FaceColor',[.5,.65,.85],'FaceAlpha',.42,'EdgeColor',[.34,.47,.62],'EdgeAlpha',.12)
axis equal
view(3)
