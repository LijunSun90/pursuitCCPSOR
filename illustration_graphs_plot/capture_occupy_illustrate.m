%capture_occupy_illustrate -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Illustrate the capture definition that the prey's position is 
%       occupied by a predator.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Sep 19, 2019
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

offset_diagonal = [-1, -1];
offset_horizontal = [-1, 0];
offset_vertical = [0, -1];
offsets = [offset_diagonal; offset_horizontal; offset_vertical];

for idx = 1:3
    offset = offsets(idx, :);
    pr_robot = p_target + offset;
    if isequal(offset, offset_diagonal)
        offset_common_neighbors = [pr_robot(1)-p_target(1),0;...
                                   0, pr_robot(2)-p_target(2)];
    elseif isequal(offset, offset_horizontal)
        offset_common_neighbors = [0, 1;...
                                   0, -1];
    elseif isequal(offset, offset_vertical)
        offset_common_neighbors = [1, 0;...
                                  -1, 0];        
    end
    % END if isequal(offset, offset_diagonal)
    common_neighbors = p_target+ offset_common_neighbors;
    
    common_neighbor_1 = common_neighbors(1, :);
    common_neighbor_2 = common_neighbors(2, :);
    
    vertices_offsets = [-0.5,-0.5;0.5,-0.5;0.5,0.5;-0.5,0.5];

    common_neighbor_1_vertices = common_neighbor_1 + vertices_offsets;
    common_neighbor_2_vertices = common_neighbor_2 + vertices_offsets;  
    
    face_alpha = 0.3;
    
    %% create the map
    f = map_create(map_w,map_h,true,true);
    
    %% plot a robot
    hold on; 
    scatter_robots = scatter(pr_robot(:,1),pr_robot(:,2),500,...
                             'filled','s',...
                             'MarkerEdgeColor','b','MarkerFaceColor','b');
                         
    %% plot the moving directions
    quiver_vector = offset_common_neighbors;
    quiver_start = repmat(p_target,size(quiver_vector,1));
    hold on;
    h_quivers = quiver(quiver_start(:,1),quiver_start(:,2),...
                       quiver_vector(:,1),quiver_vector(:,2),1.0,...
                       'Color','k','LineWidth',1,'MaxHeadSize',0.8);

    %% plot the target
    hold on; 
    scatter_target = scatter(p_target(1),p_target(2),700,'filled','p',...
        'MarkerEdgeColor','r','MarkerFaceColor','r');  

    %% plot the common neighbors
    hold on;
    h_neighbor_1 = fill(common_neighbor_1_vertices(:,1),...
                        common_neighbor_1_vertices(:,2),...
                        'k','FaceAlpha',face_alpha);
    hold on;
    h_neighbor_2 = fill(common_neighbor_2_vertices(:,1),...
                        common_neighbor_2_vertices(:,2),...
                        'k','FaceAlpha',face_alpha);  
                    
    %% add the text comments
    legend([scatter_robots,scatter_target,h_quivers,h_neighbor_1],...
        {'predator','prey','moving directions causing capture',...
        'common neighbors'},'Location','northeast');  

    %% save the axes
    % get the frame
    frame_name = char(docs_dir + "capture_occupy_" + int2str(idx) + ".png");
    frame = getframe(f.CurrentAxes);
    imwrite(frame.cdata, frame_name);    

    %% cloes figure
    % close(f);    
end
% END for idx = 1:3
