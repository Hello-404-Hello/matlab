step=0:20;
c=1e11*0.1.^step;
idx=find(c<4.31,1);
disp([step(idx-1:idx)',c(idx-1:idx)'])
