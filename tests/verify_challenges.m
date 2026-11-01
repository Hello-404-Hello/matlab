function verify_challenges
root=fileparts(fileparts(mfilename('fullpath')));
folder=fullfile(root,'第一轮作业题');
image_folder=fullfile(folder,'运行结果','图片');
set(0,'DefaultFigureVisible','off');
original=pwd;
cleanup=onCleanup(@() cd(original));
cd(folder);
report={'# 挑战题运行结果','','MATLAB R2025a 实际运行记录。每题 8 个独立版本。','',...
    'Q19 通过深色前景投影分割字符，比较归一化字符与多数模板；按差异分数的最大间隙筛出异常，不预设异常坐标。A1 为第9行第5列；A2 有第4行第3列和第9行第5列两处。','',...
    'Q20 样本量小，题面没有待测标本的真实标签。各方法采用不同距离或分布假设，允许分类结果不同；线性判别与3近邻把第三个标本归为 Ref，标准化最近均值与二次判别归为 Rn。各版本会输出自己的分类结果。','',...
    'Q21 默认随机发牌。另用题面例子、必须出现分数中间结果的牌组和无解牌组验证，每个表达式核对数值为24且四张牌恰好各用一次。','',...
    'Q22 四种以上独立思路均得到8条边、9城连通、无环，总长度38；枚举版还检查全部3003个八边组合。题面未给长度单位和单价，因此不另造单位或货币成本。',''};
for question_number=19:22
    for version_number=1:8
        file=sprintf('Q%d_%d.m',question_number,version_number);
        [text,out]=run_one(fullfile(folder,file),question_number);
        if question_number==19
            assert(isequal(out.result,[1,9,5;2,4,3;2,9,5]));
        elseif question_number==20
            assert(numel(out.label)==3&&all(ismember(out.label,[0,1])));
        elseif question_number==21
            check_expression(out.a,out.s);
        else
            assert(size(out.tree,1)==8&&out.total==38);
            group=1:9;
            for j=1:8
                u=out.tree(j,1); v=out.tree(j,2);
                assert(group(u)~=group(v));
                group(group==group(v))=group(u);
            end
            assert(numel(unique(group))==1);
        end
        report=[report,{['## ' file],'','```text',strtrim(text),'```',''}];
        figures=findall(0,'Type','figure');
        if ~isempty(figures)
            [~,order]=sort([figures.Number]); figures=figures(order);
        end
        for j=1:numel(figures)
            name=sprintf('Q%d_%d_%d.png',question_number,version_number,j);
            exportgraphics(figures(j),fullfile(image_folder,name),'Resolution',110);
            report=[report,{['![' name '](<运行结果/图片/' name '>)'],''}];
        end
        close all
        fprintf('Verified Q%d_%d\n',question_number,version_number);
    end
end
temporary=tempname; mkdir(temporary);
temp_cleanup=onCleanup(@() rmdir(temporary,'s'));
cases=[3,8,8,9;3,3,8,8;1,5,5,5;1,1,1,1];
for version_number=1:8
    source=fileread(fullfile(folder,sprintf('Q21_%d.m',version_number)));
    for case_number=1:size(cases,1)
        code=strrep(source,'a=randi([1,10],1,4);',['a=' mat2str(cases(case_number,:)) ';']);
        file=fullfile(temporary,sprintf('case_%d_%d.m',version_number,case_number));
        fid=fopen(file,'w','n','UTF-8'); fprintf(fid,'%s',code); fclose(fid);
        [~,out]=run_one(file,21);
        if case_number==4
            assert(isempty(out.s));
        else
            assert(~isempty(out.s)); check_expression(out.a,out.s);
        end
    end
end
fid=fopen(fullfile(folder,'挑战题运行结果.md'),'w','n','UTF-8');
fprintf(fid,'%s\n',report{:}); fclose(fid);
fprintf('PASS: 32 challenge scripts, 32 fixed 24-point cases, image locations and MST verified.\n');
end

function [text,out]=run_one(code_path,question_number)
tree=[]; total=[];
text=evalc('run(code_path)'); out=struct;
if question_number==19, out.result=result;
elseif question_number==20, out.label=label;
elseif question_number==21, out.a=a; out.s=s;
else, out.tree=tree; out.total=total;
end
end

function check_expression(a,s)
if isempty(s), return, end
assert(abs(eval(s)-24)<1e-8);
cards=str2double(regexp(s,'\d+','match'));
assert(isequal(sort(cards),sort(a)));
end
