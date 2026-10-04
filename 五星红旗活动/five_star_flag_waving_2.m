%% ========================================================================
%  五星红旗飘动动画   (纯 MATLAB 实现，不需要任何工具箱)
%  ------------------------------------------------------------------------
%  原理：
%    1) 用 inpolygon 按 GB 12982 标准在网格上"画"出国旗贴图（红底 + 五颗黄星）
%    2) 把贴图作为纹理映射到 30 x 20 的 3D 网格上
%    3) 每帧沿 z 方向施加一列"行波"位移：左边缘绑死在旗杆上（位移恒为 0），
%       越靠右摆动越大，形成飘扬效果
%  运行：直接运行本脚本即可。
%  说明：文件为 UTF-8 编码，MATLAB R2020a 及以上可直接正确显示中文注释。
% ========================================================================
clear; clc; close all;

%% ----------------------- 1. 可调参数 ----------------------------------
L  = 30;   H  = 20;       % 旗面尺寸（国旗标准长宽比 3:2，此处单位任意）
Nx = 201;  Ny = 134;      % 网格分辨率：越大越细腻，卡顿就调小（如 121 x 81）

amp     = 1.70;           % 起伏幅度（旗面高度为 20，1.7 约等于 8.5%）
lambda  = 13;             % 波长：越大波越舒缓
freq    = 0.90;           % 摆动频率 (Hz)
k       = 2*pi/lambda;    % 波数
w       = 2*pi*freq;      % 角频率

fps     = 30;             % 帧率
nFrames = 300;            % 总帧数（改成 Inf 就会一直飘，关掉窗口即停）

saveVideo = false;        % true = 把动画导出成 MP4
videoName = 'flag_animation.mp4';
% ----------------------------------------------------------------------

%% ----------------------- 2. 生成国旗贴图 ------------------------------
tex = makeFlagTexture(Nx, Ny);      % ny x nx x 3 的彩图，第 1 行对应旗面底部

%% ----------------------- 3. 建网格 + 画布 -----------------------------
[x, y] = meshgrid(linspace(0, L, Nx), linspace(0, H, Ny));

% 固定端权重：x = 0（旗杆侧）为 0，x = L（自由端）最大
grow = (x / L) .^ 1.25;

fig = figure('Color', [0.93 0.94 0.97], 'Position', [180 90 1060 680], ...
             'Name', '五星红旗', 'NumberTitle', 'off');
ax  = axes('Parent', fig, 'Position', [0 0 1 1]);   %#ok<LAXES>
hold(ax, 'on'); axis(ax, 'off');

% ---- 旗杆（半径 0.18 的圆柱，轴向沿 y）----
[cx, cy, cz] = cylinder(0.18, 24);
surf(ax, -0.18 + cx, -1.5 + 24*cz, cy, ...
     'FaceColor', [0.62 0.63 0.67], 'EdgeColor', 'none');

% ---- 杆顶小球 ----
[sx, sy, sz] = sphere(18);
surf(ax, -0.18 + 0.30*sx, 22.5 + 0.30*sy, 0.30*sz, ...
     'FaceColor', [0.85 0.72 0.25], 'EdgeColor', 'none');

% ---- 旗面：纹理映射到 3D 网格 ----
flagSurf = surf(ax, x, y, zeros(size(x)), tex, ...
                'FaceColor', 'texturemap', 'EdgeColor', 'none');
set(flagSurf, 'AmbientStrength', 0.58, 'DiffuseStrength', 0.75, ...
              'SpecularStrength', 0.12, 'SpecularExponent', 14, ...
              'BackFaceLighting', 'reverselit');

% ---- 光照与视角 ----
lighting(ax, 'gouraud');
camlight(ax, -35, 40);
camproj(ax, 'perspective');
view(ax, [-20 18]);

xlim(ax, [-1 33]);  ylim(ax, [-4 26]);  zlim(ax, [-7 7]);
daspect(ax, [1 1 1]);

%% ----------------------- 4. 逐帧动画 ----------------------------------
if saveVideo
    vw = VideoWriter(videoName, 'MPEG-4');
    vw.FrameRate = fps;
    open(vw);
end

t0 = tic;  n = 0;
while ishandle(fig) && n < nFrames
    n = n + 1;
    t = (n - 1) / fps;

    % 沿 +x 传播的主行波，外加一个较弱的交叉波；两项都乘 grow 保证旗杆侧不动
    ph1 = k*x - w*t + 1.5*(y/H);                      % 波前沿 y 略倾斜
    ph2 = 0.55*k*x + 0.45*w*t - 2.0*(y/H);
    Z   = grow .* ( amp*sin(ph1) + 0.30*amp*sin(ph2) );

    % 自由端略微下垂，增加"布料重量感"
    Yd = y - 1.1 * grow;

    set(flagSurf, 'YData', Yd, 'ZData', Z);
    drawnow;

    if saveVideo
        writeVideo(vw, getframe(fig));
    end

    % 限速，让播放速度接近真实时间
    waitT = n/fps - toc(t0);
    if waitT > 0, pause(waitT); end
end

if saveVideo
    close(vw);
    fprintf('动画已导出：%s\n', videoName);
end

%% ========================================================================
%  子函数：按 GB 12982 标准生成国旗贴图
%  标准坐标：旗面 30(宽) x 20(高)
%    大星：中心 (5,15)、外接圆半径 3，一个角朝正上方
%    小星：中心 (10,18) (12,16) (12,13) (10,11)，半径 1，
%          每颗各有一个角指向大星中心
%  （以上坐标原点在旗面左下角，等效于国标中"距左上角(5,5)"等描述）
% ========================================================================
function C = makeFlagTexture(nx, ny)
    red    = [238  28  37] / 255;    % 中国红
    yellow = [255 222   0] / 255;    % 星黄

    [U, V] = meshgrid(linspace(0, 1, nx), linspace(0, 1, ny));
    X = U * 30;                      % 0 -> 30（向右）
    Y = (1 - V) * 20;                % V=0 在图像顶部 -> Y=20（旗顶）

    % 大星
    mask = false(ny, nx);
    [px, py] = starPoly(5, 15, 3, 90);
    mask = mask | inpolygon(X, Y, px, py);

    % 四颗小星：顶点方向 = 由小星指向大星中心
    smallC = [10 18; 12 16; 12 13; 10 11];
    for i = 1:4
        ang = atan2d(15 - smallC(i,2), 5 - smallC(i,1));
        [px, py] = starPoly(smallC(i,1), smallC(i,2), 1, ang);
        mask = mask | inpolygon(X, Y, px, py);
    end

    % 上色（红底 + 黄星）
    C = zeros(ny, nx, 3);
    for c = 1:3
        C(:,:,c) = red(c) + (yellow(c) - red(c)) * mask;
    end

    % surf 的第 1 行对应 y = 0（旗面底部），故上下翻转一次
    C = flipud(C);
end

%% ------------------------------------------------------------------------
%  子函数：生成正五角星的 10 个顶点
%    cx, cy : 星心
%    r      : 外接圆半径
%    tipDeg : 第一个外顶点的方位角（度）；0 = 指向 +x，90 = 指向 +y
% ------------------------------------------------------------------------
function [px, py] = starPoly(cx, cy, r, tipDeg)
    rIn = r * sind(18) / sind(54);        % 内接圆半径 ≈ 0.382 r
    a   = deg2rad(tipDeg) + (0:9) * pi/5; % 每 36° 一个顶点
    rr  = repmat([r, rIn], 1, 5);
    px  = cx + rr .* cos(a);
    py  = cy + rr .* sin(a);
end
