%orthogonal_obstacles_illustrate -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Illustrate the definition of the orthogonal obstacles.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Jan 15, 2019
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

map_w = 5;
map_h = 5;

pr_robots = [3,3];

p_target = [3,3];

obstacle_east = pr_robots + [1,0];
obstacle_north = pr_robots + [0,1];
obstacle_west = pr_robots + [-1,0];
obstacle_south = pr_robots + [0,-1];

vertices_offsets = [-0.5,-0.5;0.5,-0.5;0.5,0.5;-0.5,0.5];

obstacle_vertices_east = obstacle_east + vertices_offsets;
obstacle_vertices_north = obstacle_north + vertices_offsets;
obstacle_vertices_west = obstacle_west + vertices_offsets;
obstacle_vertices_south = obstacle_south + vertices_offsets;

face_alpha = 0.3;

%% create the map
f = map_create(map_w,map_h,true,true);

%% plot a robot
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
                         'MarkerEdgeColor','b','MarkerFaceColor','b');

%% plot the diagonal moving directions
quiver_vector = [1,1;-1,1;-1,-1;1,-1];
quiver_start = repmat(pr_robots,size(quiver_vector,1));
hold on;
h_quivers = quiver(quiver_start(:,1),quiver_start(:,2),...
                   quiver_vector(:,1),quiver_vector(:,2),1.0,...
                   'Color','k','LineWidth',1,'MaxHeadSize',0.8);

%% plot the target
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

%% plot the orthogonal obstacles
hold on;
h_obstacle = fill(obstacle_vertices_east(:,1),obstacle_vertices_east(:,2),...
    'k','FaceAlpha',face_alpha);
hold on;
fill(obstacle_vertices_north(:,1),obstacle_vertices_north(:,2),...
    'k','FaceAlpha',face_alpha);
hold on;
fill(obstacle_vertices_west(:,1),obstacle_vertices_west(:,2),...
    'k','FaceAlpha',face_alpha);
hold on;
fill(obstacle_vertices_south(:,1),obstacle_vertices_south(:,2),...
    'k','FaceAlpha',face_alpha);

%% add the text comments
legend([scatter_robots,scatter_target,h_quivers,h_obstacle],...
    {'current position','current position','diagonal move directions',...
    'orthogonal obstalces'},'Location','northwest');

%% save the axes
% get the frame
frame_name = char(docs_dir + "orthogonal_obstacles.png");
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

%% cloes figure
% close(f);
