clear
x=round(rand(11));
y=round(rand(11));
results=zeros(11,11,2);
results(:,:,2)=x*y;
results(:,:,1)=x.*y;
names={'A.*B','A*B'};
figure
for p=1:2
    subplot(1,2,p)
    imshow(results(:,:,p),[])
    title(names{p})
end
