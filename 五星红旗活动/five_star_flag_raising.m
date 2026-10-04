function [fig, stats] = five_star_flag_raising_v2(userCfg)
%FIVE_STAR_FLAG_RAISING_V2 长旗杆、小旗面、明显静垂，并自动升至杆顶。
% 保存本文件后直接运行：
%   five_star_flag_raising_v2
%   five_star_flag_raising_v2(struct('poleH', 76))
%   five_star_flag_raising_v2(struct('L', 18))  % H 自动按 3:2 配套
%   five_star_flag_raising_v2(struct('tFly', Inf))
%   [fig, stats] = five_star_flag_raising_v2(struct('saveVideo', true));
%
% 主要参数（在 makeConfig 中修改，或通过结构体传入）：
%   poleH = 68       杆身顶端的高度；金球放在此高度上方
%   L = 21, H = 14   展开后的旗面尺寸；只传 L 或 H 时自动保持 3:2
%   topGap = 0       旗顶与杆身顶端的间距；默认无间隙
%   hangWidth = .22  静垂时的水平宽度比例，越小越靠近旗杆
%   gather = .78     静垂时自由端的收拢程度，范围 [0,1)
%   sagMax          低位整体下垂量；默认随旗高计算
%   yLow            起始下挂点高度；默认按下垂量和离地高度自动计算
%   tHold, tRaise, tFly  静垂、升旗、顶端飘扬的时长（秒）
%
% yHigh 不再作为可调参数：始终由 poleH - topGap - H 自动计算。
% 改杆高或旗面尺寸后，不会再因忘改 yHigh 而停在半空。
% 下垂是为动画效果设计的几何形变，并非真实布料动力学仿真。
% 函数不清空工作区，不关闭其他图窗；关闭本图窗或 Ctrl+C 停止。
% 采用基础 MATLAB 图形和 VideoWriter；本文件未在 MATLAB 中实机验证。

    if nargin < 1
        userCfg = struct();
    end
    c = makeConfig(userCfg);
    b = precomputeBasis(c);
    tex = makeFlagTexture(c.texNx, c.texNy);
    s = createScene(c, b, tex);
    fig = s.fig;
    stats = struct('frames', 0, 'elapsedSeconds', 0, 'actualFPS', 0, ...
        'targetFPS', c.fps, 'completed', false, 'videoPath', '', ...
        'poleHeight', c.poleH, 'targetTopHeight', c.poleH-c.topGap, ...
        'finalTopHeight', c.yLow+c.H, 'reachedTop', false, ...
        'meshSize', [c.Ny, c.Nx], 'textureSize', [c.texNy, c.texNx]);

    lastP = updateFrame(s, c, b, 0, NaN);
    drawnow;
    if ~sceneAlive(s)
        return;
    end

    vw = [];
    if c.saveVideo
        [vw, stats.videoPath] = makeVideoWriter(c);
        videoCleanup = onCleanup(@()safeCloseVideo(vw)); %#ok<NASGU>
        open(vw);
    end

    duration = c.tHold + c.tRaise + c.tFly;
    frameStep = 1 / c.fps;
    % 包含终点帧。即使 tFly=0，导出也会记录完全升到顶的一帧。
    nFrames = ceil(duration * c.fps) + 1;
    frameIndex = 0;
    timer = tic;

    while sceneAlive(s)
        loopStart = toc(timer);
        if c.saveVideo
            if frameIndex >= nFrames
                stats.completed = true;
                break;
            end
            if frameIndex == nFrames-1
                t = duration;  % 末帧显式采样终点，避免浮点舍入提前结束
            else
                t = min(frameIndex * frameStep, duration);
            end
        elseif frameIndex == 0
            t = 0;
        else
            t = min(loopStart, duration);
        end

        lastP = updateFrame(s, c, b, t, lastP);
        drawnow;
        if ~sceneAlive(s)
            break;
        end
        if c.saveVideo
            try
                shot = getframe(fig);
            catch err
                if ~isgraphics(fig)
                    break;
                end
                rethrow(err);
            end
            writeVideo(vw, shot);
        end
        frameIndex = frameIndex + 1;
        stats.frames = frameIndex;

        if ~c.saveVideo
            if t >= duration
                stats.completed = true;
                break;
            end
            elapsed = toc(timer);
            waitTime = min(frameStep - (elapsed-loopStart), duration-elapsed);
            if waitTime > 0
                pause(waitTime);
            end
        end
    end

    stats.elapsedSeconds = toc(timer);
    stats.actualFPS = stats.frames / max(stats.elapsedSeconds, eps);
    stats.finalTopHeight = c.yLow + (c.yHigh-c.yLow)*lastP + c.H;
    stats.reachedTop = (lastP == 1);
    if c.saveVideo
        stats.completed = (stats.frames == nFrames);
        close(vw);
        clear videoCleanup;
        if stats.completed
            fprintf('动画已导出：%s（%d 帧）\n', stats.videoPath, stats.frames);
        else
            fprintf('录制已停止：%s（已写入 %d 帧）\n', stats.videoPath, stats.frames);
        end
    end
end

function c = makeConfig(userCfg)
    c = struct( ...
        'poleH', 68, 'L', 21, 'H', 14, 'topGap', 0, ...
        'hangWidth', 0.22, 'gather', 0.78, 'releasePower', 1.6, ...
        'sagMax', [], 'edgeSagMax', [], 'foldAmp', [], ...
        'yLow', [], 'minFlagY', 1.5, ...
        'amp', [], 'lambda', [], 'freq', 0.90, ...
        'poleX', -0.20, 'poleR0', 0.28, 'poleR1', 0.17, ...
        'Nx', 121, 'Ny', 81, 'texNx', 600, 'texNy', 400, ...
        'tHold', 3, 'tRaise', 10, 'tFly', 9, 'fps', 30, ...
        'saveVideo', false, 'videoName', 'flag_raising_v2.mp4', ...
        'overwriteVideo', false);
    validateattributes(userCfg, {'struct'}, {'scalar'}, mfilename, 'userCfg');
    names = fieldnames(userCfg);
    for i = 1:numel(names)
        name = names{i};
        if strcmp(name, 'yHigh')
            error('FlagAnimation:AutomaticTop', ...
                'yHigh 已改为自动计算。请删除该参数；旗顶留空请设置 topGap。');
        end
        if ~isfield(c, name)
            error('FlagAnimation:UnknownOption', '未知参数：%s', name);
        end
        c.(name) = userCfg.(name);
    end

    % 先检查尺寸，再计算派生默认值，避免非法参数参与运算。
    validateattributes(c.L, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'positive'}, mfilename, 'L');
    validateattributes(c.H, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'positive'}, mfilename, 'H');
    c.L = double(c.L);
    c.H = double(c.H);
    if isfield(userCfg, 'L') && ~isfield(userCfg, 'H')
        c.H = c.L * (2/3);
    elseif isfield(userCfg, 'H') && ~isfield(userCfg, 'L')
        c.L = c.H * (3/2);
    end
    if isempty(c.sagMax),     c.sagMax = 0.42*c.H; end
    if isempty(c.edgeSagMax), c.edgeSagMax = 0.06*c.H; end
    if isempty(c.foldAmp),    c.foldAmp = 0.095*c.H; end
    if isempty(c.amp),        c.amp = 0.10*c.H; end
    if isempty(c.lambda),     c.lambda = 0.48*c.L; end

    positive = {'L', 'H', 'poleH', 'poleR0', 'poleR1', 'lambda', ...
        'hangWidth', 'releasePower', 'tRaise', 'fps'};
    nonnegative = {'topGap', 'gather', 'sagMax', 'edgeSagMax', ...
        'foldAmp', 'amp', 'freq', 'tHold', 'minFlagY'};
    numericNames = [positive, nonnegative, {'poleX'}];
    for i = 1:numel(numericNames)
        name = numericNames{i};
        rules = {'scalar', 'real', 'finite'};
        if any(strcmp(name, positive))
            rules{end+1} = 'positive';
        elseif any(strcmp(name, nonnegative))
            rules{end+1} = 'nonnegative';
        end
        validateattributes(c.(name), {'numeric'}, rules, mfilename, name);
        c.(name) = double(c.(name));
    end
    if c.hangWidth > 1 || c.gather >= 1
        error('FlagAnimation:InvalidDrape', ...
            '需满足 0<hangWidth<=1，且 0<=gather<1。');
    end

    % 低位自动抬高到恰好不穿地的位置；不是逐点硬裁剪旗面。
    if isempty(c.yLow)
        c.yLow = max(4.2, c.sagMax+c.edgeSagMax+c.minFlagY);
    end
    validateattributes(c.yLow, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'positive'}, mfilename, 'yLow');
    c.yLow = double(c.yLow);
    c.yHigh = c.poleH - c.topGap - c.H;  % 关键修复：终点随杆高和旗高联动
    c.hoistX = c.poleX + max(c.poleR0, c.poleR1) + 0.035;
    if c.poleH <= 3.4 || ~isfinite(c.yHigh) || c.yHigh <= c.yLow
        error('FlagAnimation:InvalidGeometry', ...
            '杆高不足以完成升旗：需满足 poleH-topGap-H > yLow，且 poleH>3.4。');
    end
    if c.yLow-c.sagMax-c.edgeSagMax < c.minFlagY-1e-10
        error('FlagAnimation:BelowGround', ...
            'yLow 过低。请留空自动计算，或设为不小于 sagMax+edgeSagMax+minFlagY。');
    end

    gridNames = {'Nx', 'Ny', 'texNx', 'texNy'};
    for i = 1:numel(gridNames)
        name = gridNames{i};
        validateattributes(c.(name), {'numeric'}, ...
            {'scalar', 'real', 'finite', 'integer', '>=', 3}, mfilename, name);
        c.(name) = double(c.(name));
    end
    validateattributes(c.tFly, {'numeric'}, ...
        {'scalar', 'real', 'nonnegative', 'nonnan'}, mfilename, 'tFly');
    c.tFly = double(c.tFly);
    boolNames = {'saveVideo', 'overwriteVideo'};
    for i = 1:numel(boolNames)
        name = boolNames{i};
        validateattributes(c.(name), {'logical', 'numeric'}, ...
            {'scalar', 'real', 'finite', 'binary'}, mfilename, name);
        c.(name) = logical(c.(name));
    end
    if isstring(c.videoName) && isscalar(c.videoName) && ~ismissing(c.videoName)
        c.videoName = char(c.videoName);
    end
    validateattributes(c.videoName, {'char'}, {'row', 'nonempty'}, ...
        mfilename, 'videoName');
    total = c.tHold+c.tRaise+c.tFly;
    if ~isfinite(c.tHold+c.tRaise) || (isfinite(c.tFly) && ~isfinite(total))
        error('FlagAnimation:InvalidDuration', '时间参数过大。');
    end
    if c.saveVideo && (~isfinite(total) || ~isfinite(total*c.fps))
        error('FlagAnimation:InfiniteVideo', '导出视频需要有限的总时长和帧数。');
    end
end

function b = precomputeBasis(c)
    [b.x, b.y] = meshgrid(linspace(0, c.L, c.Nx), linspace(0, c.H, c.Ny));
    u = b.x/c.L;
    v = b.y/c.H;

    % 下垂态：向杆侧收窄，且自由端收拢。左侧整条固定边不变。
    % 弯曲项仍保持 X 随 u 单调，避免旧式过度收缩造成网格反折。
    bow = 0.35*(1-c.hangWidth);
    hangX = c.hangWidth*b.x .* (1+bow*(1-u));
    b.contract = b.x-hangX;
    b.sag = c.sagMax*u.^1.40 ...
          + c.gather*b.y.*u.^1.10 ...
          + c.edgeSagMax*u.^1.20.*(1-v).^1.35;
    b.fold = c.foldAmp*(sin(4.5*pi*u)+0.25*sin(9*pi*u)) ...
           .*u.*(0.55+0.45*sin(pi*v));

    grow = u.^1.15;
    k = 2*pi/c.lambda;
    b.w = 2*pi*c.freq;
    phase1 = k*b.x+1.5*v;
    phase2 = 0.55*k*b.x-2*v+pi;
    b.s1 = grow.*sin(phase1);
    b.c1 = grow.*cos(phase1);
    b.s2 = 0.30*grow.*sin(phase2);
    b.c2 = 0.30*grow.*cos(phase2);
end

function p = updateFrame(s, c, b, t, lastP)
    if t <= c.tHold
        p = 0;
    elseif t >= c.tHold+c.tRaise
        p = 1;                   % 明确包含终点，不依赖浮点舍入
    else
        q = (t-c.tHold)/c.tRaise;
        p = max(0, min(1, q*q*(3-2*q))); % 单调缓入缓出
    end
    sw = p^c.releasePower;        % 越接近杆顶，越展开
    weak = 1-sw;                 % 最低处恰为 1，最高处恰为 0
    tRel = t-(c.tHold+c.tRaise);
    gust = 0;
    if tRel > 0
        gust = 0.25*exp(-tRel/1.5)*sin(2*pi*1.4*tRel);
    end
    theta = b.w*t;
    wave = b.s1*cos(theta)-b.c1*sin(theta) ...
         + b.s2*cos(0.45*theta)+b.c2*sin(0.45*theta);
    Z = (0.04+0.96*sw)*c.amp*(1+gust)*wave+weak*b.fold;
    if p ~= lastP
        yOff = c.yLow+(c.yHigh-c.yLow)*p;
        if p == 1
            yOff = c.yHigh;       % 显式落在最终挂点，避免累加误差
        end
        X = c.hoistX+b.x-weak*b.contract;
        Y = yOff+b.y-weak*b.sag;
        set(s.flag, 'XData', X, 'YData', Y, 'ZData', Z);
        set(s.rope, 'YData', [yOff+c.H, c.poleH, NaN, yOff, 1.7]);
    else
        set(s.flag, 'ZData', Z);
    end
end

function s = createScene(c, b, tex)
    s.fig = figure('Color', [0.89 0.92 0.96], ...
        'Position', [120 60 880 780], ...
        'Name', '五星红旗升旗动画（加长旗杆 / 强化静垂 / 自动到顶）', ...
        'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none');
    if c.saveVideo
        set(s.fig, 'Resize', 'off');
    end
    ax = axes('Parent', s.fig, 'Position', [0 0 1 1]);
    hold(ax, 'on');
    axis(ax, 'off');
    th = linspace(0, 2*pi, 73);
    fill3(ax, c.poleX+13*cos(th), -2.6*ones(size(th)), 13*sin(th), ...
        [0.87 0.89 0.88], 'EdgeColor', 'none');
    drawTube(ax, 2.30, 2.30, -2.6, 1.7, [0.80 0.80 0.83], c.poleX);
    drawCap(ax, 2.30, 1.7, [0.80 0.80 0.83], c.poleX);
    drawTube(ax, 1.15, 1.15, 1.7, 3.4, [0.71 0.71 0.75], c.poleX);
    drawCap(ax, 1.15, 3.4, [0.71 0.71 0.75], c.poleX);
    drawTube(ax, c.poleR0, c.poleR1, 3.4, c.poleH, [0.66 0.67 0.70], c.poleX);

    % 金球坐在杆身顶端上方，旗顶对齐 poleH 时不会穿入金球。
    [sx, sy, sz] = sphere(20);
    ballR = 0.62;
    surf(ax, c.poleX+ballR*sx, c.poleH+ballR+ballR*sy, ballR*sz, ...
        'FaceColor', [0.88 0.74 0.26], 'EdgeColor', 'none');
    rx = c.hoistX+0.02;
    s.rope = plot3(ax, [rx rx NaN rx rx], [0 0 NaN 0 0], ...
        [0.08 0.08 NaN 0.08 0.08], ...
        'Color', [0.28 0.28 0.32], 'LineWidth', 1.1);
    s.flag = surface('Parent', ax, 'XData', c.hoistX+b.x, ...
        'YData', b.y, 'ZData', zeros(size(b.x)), 'CData', tex, ...
        'FaceColor', 'texturemap', 'EdgeColor', 'none', ...
        'AmbientStrength', 0.58, 'DiffuseStrength', 0.76, ...
        'SpecularStrength', 0.12, 'SpecularExponent', 14, ...
        'BackFaceLighting', 'reverselit');

    daspect(ax, [1 1 1]);
    camproj(ax, 'perspective');
    xlim(ax, [c.poleX-14, max(c.hoistX+c.L+5, c.poleX+14)]);
    ylim(ax, [-6, c.poleH+4]);
    zRange = max(15, 2*c.amp+1.25*c.foldAmp+1);
    zlim(ax, [-zRange, zRange]);
    span = max(c.L, c.poleH);
    target = [c.poleX+0.28*c.L, (c.poleH-2.6)/2, 0];
    camtarget(ax, target);
    campos(ax, target+[0.45*c.L, 0.09*c.poleH, 2.15*span]);
    camup(ax, [0 1 0]);
    camva(ax, 30);
    lighting(ax, 'gouraud');
    camlight(ax, -40, 45);
end

function tf = sceneAlive(s)
    tf = isgraphics(s.fig) && isgraphics(s.flag) && isgraphics(s.rope);
end

function [vw, filename] = makeVideoWriter(c)
    [folder, base, ext] = fileparts(c.videoName);
    if isempty(folder), folder = pwd; end
    if isempty(ext), ext = '.mp4'; end
    if isempty(base) || ~isfolder(folder)
        error('FlagAnimation:VideoPath', '视频文件名不能为空，且输出目录必须存在。');
    end
    profiles = VideoWriter.getProfiles();
    profileNames = {profiles.Name};
    if any(strcmpi(ext, {'.mp4', '.m4v'}))
        if any(strcmp('MPEG-4', profileNames))
            profile = 'MPEG-4';
        else
            profile = 'Motion JPEG AVI';
            ext = '.avi';
            warning('FlagAnimation:VideoFallback', ...
                '当前环境未提供 MPEG-4 编码器，将改为输出 AVI。');
        end
    elseif strcmpi(ext, '.avi')
        profile = 'Motion JPEG AVI';
    else
        error('FlagAnimation:VideoFormat', '仅支持 .mp4、.m4v 或 .avi。');
    end
    if ~any(strcmp(profile, profileNames))
        error('FlagAnimation:VideoProfile', '当前环境不支持视频格式：%s', profile);
    end
    filename = fullfile(folder, [base, lower(ext)]);
    if isfile(filename) && ~c.overwriteVideo
        error('FlagAnimation:FileExists', ...
            '文件已存在：%s。请更换文件名或设置 overwriteVideo=true。', filename);
    end
    vw = VideoWriter(filename, profile);
    vw.FrameRate = c.fps;
    vw.Quality = 95;
end

function safeCloseVideo(vw)
% 仅用于异常/中断时的尽力清理；正常路径中的 close 会直接报告错误。
    try
        close(vw);
    catch
        % 不用清理异常遮盖原始的编码、写盘或中断原因。
    end
end

function drawTube(ax, r0, r1, y0, y1, col, xc)
    [cx, cy, cz] = cylinder(1, 40);
    r = r0 + (r1-r0)*cz;
    surf(ax, xc+r.*cx, y0+(y1-y0)*cz, r.*cy, ...
        'FaceColor', col, 'EdgeColor', 'none');
end

function drawCap(ax, r, y, col, xc)
    th = linspace(0, 2*pi, 49);
    fill3(ax, xc+r*cos(th), y*ones(size(th)), r*sin(th), col, 'EdgeColor', 'none');
end

function C = makeFlagTexture(nx, ny)
% 保留原文件的五星位置与朝向；第 1 行直接对应旗底，无需 flipud。
    [X, Y] = meshgrid(linspace(0, 30, nx), linspace(0, 20, ny));
    centers = [5 15; 10 18; 12 16; 12 13; 10 11];
    mask = false(ny, nx);
    for i = 1:5
        if i == 1
            radius = 3;
            angle = 90;
        else
            radius = 1;
            angle = atan2d(15-centers(i,2), 5-centers(i,1));
        end
        [px, py] = starPoly(centers(i,1), centers(i,2), radius, angle);
        mask = mask | inpolygon(X, Y, px, py);
    end
    red = uint8([238 28 37]);
    yellow = uint8([255 222 0]);
    C = zeros(ny, nx, 3, 'uint8');
    for channel = 1:3
        plane = repmat(red(channel), ny, nx);
        plane(mask) = yellow(channel);
        C(:,:,channel) = plane;
    end
end

function [px, py] = starPoly(cx, cy, radius, tipDeg)
    innerRadius = radius * sind(18) / sind(54);
    angles = deg2rad(tipDeg) + (0:9)*pi/5;
    rr = repmat([radius, innerRadius], 1, 5);
    px = cx + rr.*cos(angles);
    py = cy + rr.*sin(angles);
end
