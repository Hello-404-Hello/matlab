clear
letters=['a':'z','A':'Z'];
pool=[letters,'0':'9','_'];
names=cell(100,1);
valid=false(100,1);
errors=cell(100,1);
for i=1:100
    len=randi(namelengthmax+10);
    name=pool(randi(length(pool),1,len));
    names{i}=name;
    reason='';
    if(~isletter(name(1)))
        reason=[reason,'首字符不是字母;'];
    end
    if length(name)>namelengthmax
        reason=[reason,'长度超限;'];
    end
    if iskeyword(name)
        reason=[reason,'MATLAB关键词;'];
    end
    valid(i)=isvarname(name);
    if valid(i)
        reason='通过';
    end
    errors{i}=reason;
    fprintf('%3d\t%s\t%d\t%s\n',i,name,valid(i),reason);
end
