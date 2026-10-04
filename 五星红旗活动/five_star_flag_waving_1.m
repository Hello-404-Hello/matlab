%% 程序二：五星红旗随风飘动
% 独立运行，不需要先运行 flag_static.m，也不需要外部图片。
% 使用波函数实现视觉模拟，不是布料力学仿真。
clearvars; clc;

%% 1. 基本参数
W = 30;
H = 20;
baseHeight = 5;                % 旗面下边缘的初始离地高度
A = 1.8;                       % 飘动幅度，增大后摆动更明显
windHz = 0.8;                  % 主波频率（Hz），增大后飘动更快
wavelength = 18;               % 主波波长，减小后波纹更密
fps = 30;                      % 目标帧率，实际值取决于机器性能

red    = [222 41 16] / 255;
yellow = [255 222 0] / 255;
stars = [5  15  3;
         10 18  1;
         12 16  1;
         12 13  1;
         10 11  1];
ratio = sin(pi/10) / sin(3*pi/10);

%% 2. 直接生成五星红旗的 RGB 纹理
texW = 901;
texH = 601;
[Ut,Vt] = meshgrid(linspace(0,W,texW),linspace(0,H,texH));
texture = repmat(reshape(red,1,1,3),[texH texW 1]);
starMask = false(texH,texW);

for i = 1:5
    cx = stars(i,1);
    cy = stars(i,2);
    R  = stars(i,3);

    if i == 1
        angle0 = pi/2;
    else
        angle0 = atan2(stars(1,2)-cy, stars(1,1)-cx);
    end

    theta = angle0 + (0:9)*pi/5;
    radius = R*ones(1,10);
    radius(2:2:end) = R*ratio;
    sx = cx + radius.*cos(theta);
    sy = cy + radius.*sin(theta);
    starMask = starMask | inpolygon(Ut,Vt,sx,sy);
end

for c = 1:3
    layer = texture(:,:,c);
    layer(starMask) = yellow(c);
    texture(:,:,c) = layer;
end

%% 3. 创建三维旗面；纹理精细，曲面网格适当稀疏
[U,V] = meshgrid(linspace(0,W,151),linspace(0,H,101));
envelope = (U/W).^1.2;         % 左端为零，向自由端逐渐增大

fig = figure('Name','五星红旗随风飘动：关闭窗口停止', ...
    'NumberTitle','off','Color',[0.94 0.97 1.00], ...
    'Position',[100 100 1000 700]);
ax = axes('Parent',fig,'Position',[0.03 0.03 0.94 0.94]);
hold(ax,'on');

hFlag = surf(ax,U,zeros(size(U)),baseHeight+V, ...
    'FaceColor','texturemap','CData',texture, ...
    'EdgeColor','none','FaceLighting','gouraud', ...
    'AmbientStrength',0.55,'DiffuseStrength',0.70, ...
    'SpecularStrength',0.08,'BackFaceLighting','reverselit');

% 固定旗杆
plot3(ax,[0 0],[0 0],[0 baseHeight+H+1], ...
    'Color',[0.65 0.65 0.68],'LineWidth',7);
plot3(ax,0,0,baseHeight+H+1,'o', ...
    'MarkerSize',8,'MarkerFaceColor',[0.8 0.8 0.82], ...
    'MarkerEdgeColor','none');

axis(ax,'equal');
xlim(ax,[-2 W+2]);
ylim(ax,[-1.5*A-1 1.5*A+1]);
zlim(ax,[0 baseHeight+H+2]);
view(ax,-12,10);               % 从正面略偏侧方观察；Z 轴向上
axis(ax,'vis3d');
axis(ax,'off');
light('Parent',ax,'Position',[-10 -30 45],'Style','local');

%% 4. 动画：只更新已有曲面，不重复创建图形对象
k = 2*pi/wavelength;
omega = 2*pi*windHz;
clockStart = tic;
disp('关闭动画窗口，或按 Ctrl+C 停止动画。');

while isgraphics(fig) && isgraphics(hFlag)
    frameStart = tic;
    t = toc(clockStart);        % 用实际时间控制运动速度

    % 相位随时间移动，让波纹从旗杆一侧向自由端传播
    phase = k*U - omega*t;

    % 前后摆动：叠加两组波，避免过于单调
    Y = A*envelope .* ( ...
        sin(phase + 0.4*V/H) + ...
        0.25*sin(1.8*k*U - 1.4*omega*t + 1.2*V/H));

    % 加入轻微上下起伏；左端因 envelope=0 而保持固定
    Z = baseHeight + V + ...
        0.18*A*envelope .* sin(phase + 0.8*V/H);

    set(hFlag,'YData',Y,'ZData',Z);
    drawnow;
    pause(max(0,1/fps - toc(frameStart)));
end
