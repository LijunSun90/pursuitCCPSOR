%convex_hull_illustrate -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Illustrate the definition of the convex hull.
% 
% REFERENCE:
%       S. L. Devadoss, J. O’Rourke, Discrete and computational geometry, 
%       Prince- ton University Press, 2011.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Jun 11, 2019
%-------------------------------------------------------------------------

%% clear
clear all; close all; clc;

%% define variables
docs_dir = "../data/illustrations/";

% make a new folder
if ~exist(docs_dir,'dir')
    system("mkdir -p "+docs_dir);
end
% END if ~exist(docs_dir)

% random seed
seed = 0;

% number of points
n_points = 15;

% axis range
lower_range = 0;
upper_range = 1;

% divide the axis into quotas
n_divide = 10;
quota = (upper_range - lower_range) / n_divide;

% lower and uppper bounds for these random points
lower_quota = 3;
upper_quota = 7;
lower_bound = lower_quota * quota;
upper_bound = upper_quota * quota;

% maker size of the points
marker_size = 15;

% width of the line that define the convex hull
line_width = 2;

%% generate the random points
rng(seed)
xs = (upper_bound - lower_bound) * rand(n_points, 1) + lower_bound;
ys = (upper_bound - lower_bound) * rand(n_points, 1) + lower_bound;

%% plot the pionts
f = figure;
axis([lower_range upper_range lower_range upper_range]);
% axis off;
hold on; plot(xs, ys, '.', 'MarkerSize', marker_size);

% save the axes
% get the frame
frame_name = char(docs_dir + "convex_hull_pionts.png");
set(f.CurrentAxes, 'Units', 'pixels');
f_axes_position = get(f.CurrentAxes, 'Position');
axes_quota_x = f_axes_position(3) / n_divide;
axes_quota_y = f_axes_position(4) / n_divide;
offset = [axes_quota_x * (lower_quota - 0.5), ...
          axes_quota_y * (lower_quota - 0.5)];
width = axes_quota_x * (upper_quota - lower_quota + 1);
height = axes_quota_y * (upper_quota - lower_quota + 1);
frame = getframe(f.CurrentAxes, [offset, width, height]);
imwrite(frame.cdata, frame_name);

%% plot the convex hull
f = figure;
axis([lower_range upper_range lower_range upper_range]);
% axis off;
hold on; plot(xs, ys, '.', 'MarkerSize', marker_size);
[K,~] = convhull(xs, ys);
hold on; hold on, plot(xs(K), ys(K), '-k', 'LineWidth', line_width);

% save the axes
% get the frame
frame_name = char(docs_dir + "convex_hull.png");
set(f.CurrentAxes, 'Units', 'pixels');
f_axes_position = get(f.CurrentAxes, 'Position');
axes_quota_x = f_axes_position(3) / n_divide;
axes_quota_y = f_axes_position(4) / n_divide;
offset = [axes_quota_x * (lower_quota - 0.5), ...
          axes_quota_y * (lower_quota - 0.5)];
width = axes_quota_x * (upper_quota - lower_quota + 1);
height = axes_quota_y * (upper_quota - lower_quota + 1);
frame = getframe(f.CurrentAxes, [offset, width, height]);
imwrite(frame.cdata, frame_name);
