jie=[];
for x=7:29
    for y=16:35
        if 2*x+5*y==126
            jie(end+1,:)=[x,y];
        end
    end
end
disp(jie)
