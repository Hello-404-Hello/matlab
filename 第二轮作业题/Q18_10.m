chess={[5,4],[4,6],[5,8],false};
[origin,wall,destination,pass]=chess{:};

kernel=[0,1,0,1,0;1,0,0,0,1;0,0,0,0,0;1,0,0,0,1;0,1,0,1,0];
p=false(8);
p(destination(1),destination(2))=true;
seen=p;
d=-1;
k=0;
while any(p,'all')
    if p(origin(1),origin(2)), d=k; break, end
    p=conv2(double(p),kernel,'same')>0&~seen;
    if ~pass, p(wall(1),wall(2))=false; end
    seen=seen|p;
    k=k+1;
end
disp(d)
