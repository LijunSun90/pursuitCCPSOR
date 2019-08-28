%robot_vicinity_plot -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Plot the vicinity of the real predator robot
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Jan 18, 2019
%-------------------------------------------------------------------------

%% clear
clear all; close all; clc;

%% define variables
docs_dir = "./data/illustrations/";

% make a new folder
if ~exist(docs_dir,'dir')
    system("mkdir -p "+docs_dir);
end
% END if ~exist(docs_dir)

% map
map_w = 11;
map_h = 11;

radius = 2;

% real predator robot
pr_robots = [6,4];

% virtual robot
pv_robots = [10,8];

% selected outer boundary
pb = [8,6];

% line
lines_x = [pr_robots(1);pv_robots(1)];
lines_y = [pr_robots(2);pv_robots(2)];

% rectangle
pos_rectangle = [pr_robots-radius-0.5, 2*radius+1, 2*radius+1];

% add text
txt = {"Vicinity of\rightarrow", "the real", "predator", "robot"};
pos_txt = [0.8,5.5];

%% get the outer boundary
num_elements = 8 * radius;
outer_boundary = zeros( num_elements ,2);
%
x = -radius:1:radius;
y = -radius:1:radius;
[xx,yy] = meshgrid(x,y);
%
outer_boundary(1:(2*radius+1), :) = [xx(:,1),yy(:,1)];
outer_boundary((2*radius+2):(4*radius+2), :) = [xx(:,end),yy(:,end)];
outer_boundary((4*radius+3):(6*radius+1), :) = ...
                                        [xx(1,2:end-1).',yy(1,2:end-1).'];
outer_boundary((6*radius+2):end, :) = ...
                                    [xx(end,2:end-1).',yy(end,2:end-1).'];
% add offset                                
outer_boundary = outer_boundary + pr_robots;
                                
%% plot
f = map_create(map_w,map_h,true,true);

% predator robots
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% virtual robot
hold on;
scatter_virtual_robots = ...
    scatter(pv_robots(:,1),pv_robots(:,2),300,'filled','*',...
    'MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',6);

% outer_boundary
hold on; 
scatter_boundaries = ...
    scatter(outer_boundary(:,1),outer_boundary(:,2),50,'filled','o',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% selected outer boundary
hold on; 
scatter_selected_boundary = ...
    scatter(pb(:,1),pb(:,2),200,'Marker','o',...
    'MarkerEdgeColor','g','LineWidth',2);

% plot a line
hold on;
line(lines_x,lines_y,'Color','g','LineStyle','--','LineWidth',2);

% plot a rectangle to illustrate the vicinity
hold on;
h_rect = rectangle('Position',pos_rectangle,...
    'EdgeColor','b','LineWidth',2,'LineStyle','--');

% add legend
legend([scatter_robots,...
    scatter_virtual_robots,...
    scatter_boundaries,...
    scatter_selected_boundary],...
    {"p^{i1}_{robots}: real predator robot",...
    "p^{ij}_{robots}: virtual robot",...
    "p^{i1}_{b}: boundary neighbors of p^{i1}_{robots}",...
    "nbn(p_{robots}^{ij}, p_{robots}^{i1})"},...
    'Location','northwest','FontWeight','bold');

% add text
text(pos_txt(1),pos_txt(2),txt,'Color','b','FontWeight','bold');

%% save
frame_name = char(docs_dir + "nearest_boundary_neighbor.png");
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

%% close
% close(f);

