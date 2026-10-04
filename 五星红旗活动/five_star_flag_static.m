%% 程序一：绘制静态五星红旗
% 坐标原点在旗面左下角；两个脚本可以分别独立运行。
clearvars; clc;

W = 30;                       % 旗面宽度
H = 20;                       % 旗面高度，宽高比为 3:2
red    = [222 41 16] / 255;    % 屏幕显示用的近似红色
yellow = [255 222 0] / 255;

% 每行依次为：中心 x、中心 y、外接圆半径
stars = [5  15  3;
         10 18  1;
         12 16  1;
         12 13  1;
         10 11  1];

fig = figure('Name','五星红旗（静态）', ...
    'NumberTitle','off','Color','w','Position',[100 100 900 600]);
ax = axes('Parent',fig,'Position',[0.04 0.04 0.92 0.92]);
hold(ax,'on');

% 红色旗面
patch(ax,[0 W W 0],[0 0 H H],red,'EdgeColor','none');

% 正五角星的内、外接圆半径之比
ratio = sin(pi/10) / sin(3*pi/10);

for i = 1:5
    cx = stars(i,1);
    cy = stars(i,2);
    R  = stars(i,3);

    if i == 1
        angle0 = pi/2;          % 大星的一个角尖竖直向上
    else
        % 小星的一个角尖指向大星中心
        angle0 = atan2(stars(1,2)-cy, stars(1,1)-cx);
    end

    theta = angle0 + (0:9)*pi/5;
    radius = R*ones(1,10);
    radius(2:2:end) = R*ratio;

    x = cx + radius.*cos(theta);
    y = cy + radius.*sin(theta);
    patch(ax,x,y,yellow,'EdgeColor','none');
end

axis(ax,'equal');
axis(ax,[0 W 0 H]);
axis(ax,'off');
