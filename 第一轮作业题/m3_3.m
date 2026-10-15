%%先建立随机字符矩阵,再切出100个不同长度的名称
clearvars;
alphabet=['a':'z','A':'Z','0':'9','_'];
lengths=randi([1,namelengthmax+12],100,1);
randomChars=alphabet(randi(numel(alphabet),100,max(lengths)));
Name=cell(100,1);
IsValid=false(100,1);
ErrorType=cell(100,1);
keywords=iskeyword;
for row=1:100
    Name{row}=randomChars(row,1:lengths(row));
    s=Name{row};
    reasons={};
    if(~any(s(1)==['a':'z','A':'Z']))
        reasons{end+1}='首字符必须为字母';
    end
    if numel(s)>namelengthmax
        reasons{end+1}='超过最大名称长度';
    end
    if any(strcmp(s,keywords))
        reasons{end+1}='属于关键词';
    end
    IsValid(row)=isvarname(s);
    if isempty(reasons)
        ErrorType{row}='通过';
    else
        ErrorType{row}=strjoin(reasons,';');
    end
end
result=table(Name,IsValid,ErrorType);
disp(result);

