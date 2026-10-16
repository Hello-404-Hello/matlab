rng('shuffle');
field=false(100);
field(randperm(10000,6500))=true;
reach=false(100);
reach(1,:)=field(1,:);
while true
    neighbours=[false(1,100);reach(1:end-1,:)]|...
        [reach(2:end,:);false(1,100)]|...
        [false(100,1),reach(:,1:end-1)]|...
        [reach(:,2:end),false(100,1)];
    expanded=field&(reach|neighbours);
    if isequal(expanded,reach)
        break
    end
    reach=expanded;
end
disp(double(any(reach(end,:))))
figure;
imagesc(double(field)+double(reach));
