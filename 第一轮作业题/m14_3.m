% 期望递推：帐篷长度归一化为1，场地长度为500。
% E(x)=0(x<1)，E(1)=1。
% 第一个帐篷左端均匀分布于[0,x-1]，故
% E(x)=1+2*integral(E(t),0,x-1)/(x-1)。
% 累积梯形积分从x=1处的0开始计算。
% 输出每行：[网格步长,平均帐篷数]；最后输出两次加密的差值。
step=[0.02,0.01,0.005];
result=zeros(numel(step),2);
for j=1:numel(step)
    h=step(j);
    unit=round(1/h);
    last=round(500/h);
    e=zeros(last+1,1);
    integralE=zeros(last+1,1);
    e(unit+1)=1;
    for n=unit+1:last
        x=n*h;
        e(n+1)=1+2*integralE(n-unit+1)/(x-1);
        integralE(n+1)=integralE(n)+h*(e(n)+e(n+1))/2;
    end
    result(j,:)=[h,e(end)];
end
disp(result)
disp(abs(diff(result(:,2))))
