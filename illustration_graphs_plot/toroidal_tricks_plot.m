%toroidal_tricks_plot -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Plot the tricks in the toroidal world.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Jan 12, 2019
%-------------------------------------------------------------------------

%% clear
clear all; close all; clc;

%% tricks in the toroidal world: initialization
docs_dir = "./data/illustrations/toroidal_trick/";

% make a new folder
if ~exist(docs_dir,'dir')
    system("mkdir -p "+docs_dir);
end
% END if ~exist(docs_dir)

% map: initialization
map_w = 5;
map_h = 5;
f_init = map_create(map_w,map_h,true,true);

% target prey
p_target = [3,3];
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% predator robots
pr_robots = [2,2;2,3;3,1;4,3];
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% arrow: target move direction
quiver_start_target = p_target;
quiver_vector_target = [0,1];
hold on;
quiver(quiver_start_target(1),quiver_start_target(2),...
    quiver_vector_target(1),quiver_vector_target(2),0.5,...
    'Color','r','LineWidth',1,'MaxHeadSize',0.8);

% legend
legend([scatter_target,scatter_robots],{"prey","predators"});

%% map: toroidal tricks
f_trick = map_create(map_w,map_h,true,true);

% target prey
p_target = [3,3];
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% predator robots
pr_robots = [2,2;2,3;3,1;4,3];
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% arrow: target move direction
quiver_vector_target = [0,1];
hold on;
quiver(p_target(1),p_target(2),...
    quiver_vector_target(1),quiver_vector_target(2),0.5,...
    'Color','r','LineWidth',1,'MaxHeadSize',0.8);

% arrows: predator robots' move directions
quiver_vector_predator = [1,1;0,1;0,-1;0,1];
hold on;
quiver(pr_robots(:,1),pr_robots(:,2),...
    quiver_vector_predator(:,1),quiver_vector_predator(:,2),0.5,...
    'Color','b','LineWidth',1,'MaxHeadSize',0.8);

% legend
legend([scatter_target,scatter_robots],{"prey","predators"});

%% map: toroidal tricks results
f_trick_result = map_create(map_w,map_h,true,true);

% target prey next position
p_target_next = [p_target(1),p_target(2)+1];
hold on;
scatter_target_next = scatter(p_target_next(1),p_target_next(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r',...
    'MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',0.3);


% predator robots next position
pr_robots_next = [3,3;2,4;3,5;4,4];
hold on; 
scatter_robots_next = scatter(pr_robots_next(:,1),...
    pr_robots_next(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b',...
    'MarkerEdgeAlpha',0.3,'MarkerFaceAlpha',0.3);

% target prey previous position plot
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% predator robots previous positions plot
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% arrow: target move direction
quiver_vector_target = [0,1];
hold on;
quiver(p_target(1),p_target(2),...
    quiver_vector_target(1),quiver_vector_target(2),0.5,...
    'Color','r','LineWidth',1,'MaxHeadSize',0.8);

% arrows: predator robots' move directions
quiver_vector_predator = [1,1;0,1;0,-1;0,1];
hold on;
quiver(pr_robots(:,1),pr_robots(:,2),...
    quiver_vector_predator(:,1),quiver_vector_predator(:,2),0.5,...
    'Color','b','LineWidth',1,'MaxHeadSize',0.8);


% legend
legend([scatter_target_next,scatter_robots_next,...
        scatter_target,scatter_robots],...
        {"new prey position","new predators positions",...
         "prior prey position","prior predators positions"},...
         'Location','best');

%% save result
% get the frame: initialization
frame_init_name = char(docs_dir + "toroidal_trick_init.png");
frame_init = getframe(f_init.CurrentAxes);
imwrite(frame_init.cdata, frame_init_name);

% get the frame: trick
frame_trick_name = char(docs_dir + "toroidal_trick.png");
frame_trick = getframe(f_trick.CurrentAxes);
imwrite(frame_trick.cdata, frame_trick_name);

% get the frame: trick result
frame_trick_result_name = char(docs_dir + "toroidal_trick_result.png");
frame_trick_result = getframe(f_trick_result.CurrentAxes);
imwrite(frame_trick_result.cdata, frame_trick_result_name);

%% cloes figure
% close(f_init);
% close(f_trick);
% close(f_trick_result);