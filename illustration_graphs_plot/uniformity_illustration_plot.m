%uniformity_illustration_plot -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Show a uniformity assessment deadlock and the alternative
%       uniformity assessment method.
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Jan 17, 2019
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

p_target = [3,3];
pr_robots = [2,4;3,1;3,2;4,4];

%% deadlock plot
f = map_create(map_w,map_h,true,true);

% target prey
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% predator robots
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% save
frame_name = char(docs_dir + "uniformity_deadlock.png");
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

% close
% close(f);

%% uniformity split method plot
f = map_create(map_w,map_h,true,true);

% target prey
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% split lines
lines_x = [0.5,3;5.5,3];
lines_y = [3,0.5;3,5.5];
hold on;
line(lines_x,lines_y,'Color','r','LineStyle','--','LineWidth',2);

% add text
txt = {'N_{11}','N_{12}',...
       'N_{21}','N_{22}'};
pos_txt = [1.5,4.5;4.5,4.5;...
           1.5,1.5;4.5,1.5] - [0.25,0];

text(pos_txt(:,1),pos_txt(:,2),txt,'FontSize',15);

% save
frame_name = char(docs_dir + "uniformity_split.png");
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

% close
% close(f);

%% uniformity assessment example plot
f = map_create(map_w,map_h,true,true);

% target prey
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% split lines
lines_x = [0.5,3;5.5,3];
lines_y = [3,0.5;3,5.5];
hold on;
line(lines_x,lines_y,'Color','r','LineStyle','--','LineWidth',2);

% predator robots
pr_robots = [2,3;3,2;3,4;4,3];
hold on; 
scatter_robots = scatter(pr_robots(:,1),pr_robots(:,2),500,'filled','s',...
    'MarkerEdgeColor','b','MarkerFaceColor','b');

% save
frame_name = char(docs_dir + "uniformity_assessment_example.png");
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

% close
% close(f);

%% uniformity alternative split method plot
f = map_create(map_w,map_h,true,true);

% target prey
hold on; 
scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
    'MarkerEdgeColor','r','MarkerFaceColor','r');

% split lines
lines_x = [0.5,0.5,2.5,3.5;5.5,5.5,2.5,3.5];
lines_y = [3.5,2.5,0.5,0.5;3.5,2.5,5.5,5.5];
hold on;
line(lines_x,lines_y,'Color','r','LineStyle','--','LineWidth',2);

% add text
txt = {'N_{11}','N_{12}','N_{13}',...
       'N_{21}','N_{23}',...
       'N_{31}','N_{32}','N_{33}'};
pos_txt = [1.5,4.5;3,4.5;4.5,4.5;...
           1.5,3;4.5,3;...
           1.5,1.5;3,1.5;4.5,1.5] - [0.25,0];

text(pos_txt(:,1),pos_txt(:,2),txt,'FontSize',15);

% save
frame_name = char(docs_dir + "uniformity_alternative_split.png");
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

% close
% close(f);
