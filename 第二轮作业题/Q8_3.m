v=10;
m=1e12;
for i=1:20
    m=m*(v-9)/v;
    if m/v<4.31
        break
    end
end
disp([i,m/v])
