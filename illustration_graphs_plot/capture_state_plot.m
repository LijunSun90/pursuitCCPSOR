%capture_state_plot -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Plot the capture state under the capture definition for
%       illustration.
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
    system("mkdir "+docs_dir);
end
% END if ~exist(docs_dir)

map_w = 5;
map_h = 5;

%% capture state 1
% define the frame name to be saved
frame_name = char(docs_dir + "capture_state_1.png");

% define the target -- prey robot
p_target = [3,3];

% define the offsets
capture_offsets = [1,0;0,1;-1,0;0,-1];

%% capture state 2
% define the frame name to be saved
frame_name = char(docs_dir + "capture_state_2.png");

% define the target -- prey robot
p_target = [1,3];

% define the offsets
capture_offsets = [0,-1;1,0;0,1;3,1];

%% capture state 3
% define the frame name to be saved
frame_name = char(docs_dir + "capture_state_3.png");

% define the target -- prey robot
p_target = [1,1];

% define the offsets
capture_offsets = [1,0;0,1;1,3;3,2];

%% plot
% create the map
f = map_create(map_w,map_h,true,true);

% define the predator robots
pr_robots = p_target + capture_offsets;

% plot the target
hold on;
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% plot the predator robots
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% add legend
legend([scatter_target,scatter_robots],{'prey robot','predator robots'});

%% save
% get the frame
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

%% close
% close all;
