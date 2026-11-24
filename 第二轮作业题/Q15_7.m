rng(15)
A=randi([0,1],50);
segments=[];
for t=1:4
    if t==4, B=fliplr(A); else, B=A; end
    if t<=2
        offsets=1:50;
    else
        offsets=-49:49;
    end
    for j=offsets
        if t==1
            r=repmat(j,1,50); c=1:50;
        elseif t==2
            r=1:50; c=repmat(j,1,50);
        else
            r=max(1,1-j):min(50,50-j); c=r+j;
        end
        code=char('0'+B(sub2ind(size(B),r,c)));
        id=strfind(code,'11111');
        if t==4, c=51-c; end
        if ~isempty(id)
            segments=[segments;reshape(c(id),[],1),reshape(r(id),[],1),reshape(c(id+4),[],1),reshape(r(id+4),[],1)];
        end
    end
end
figure
imagesc(A)
axis image
hold on
for k=1:size(segments,1)
    s=segments(k,:);
    plot(s([1,3]),s([2,4]),'r-','LineWidth',1)
end
disp(size(segments,1))
