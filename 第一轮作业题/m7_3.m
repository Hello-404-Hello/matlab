% switch分支。
% 输出[鸡蛋数,柚子数]；true或1表示看到柚子。
seen=1;
switch seen
    case 1
        amount=[10 1];
    case 0
        amount=[10 0];
end
disp(amount);
