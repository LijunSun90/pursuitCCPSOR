function frame_save(map_w,map_h,p_target,p_robots,frame_name)
%frame_save - save a frame of the simulation configuration
%-------------------------------------------------------------------------
% 
% INPUT:
%       map_w       - width of the simulation map
%                     Scalar
%       map_h       - height of the simulation map
%                     Scalar
%       p_target    - position of the target
%                     Matrix: 1 x n_dim (n_dim = 2)
%       p_robots    - positions of the whole population
%                     Matrix: n_robots x n_dim x pop_sz (n_dim = 2)
%       frame_name  - name of the frame, including the path and format
%                     String
% 
% OUTPUT:
%       None to return, but an image is saved to the specific path in disk.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 10, 2018
%-------------------------------------------------------------------------

%% define variables
% set animation parameters -- customer specified
% target animation parameters
ani_target_marker = 'p';
ani_target_marker_size = 80;
ani_target_marker_color = 'r';

% real robots animation parameters
ani_robot_marker = 's';
ani_robot_marker_size = 40; % 50
ani_robot_marker_color = 'b';

% virtual robots animation parameters
ani_virtual_robot_marker = '*'; % *
ani_virtual_robot_marker_size = 25; % 30
ani_virtual_robot_marker_color = 'g';


%% plot the simulation map
f = map_create(map_w,map_h,false,false); %false,false

%% plot the target
hold on;
scatter(p_target(1),p_target(2),ani_target_marker_size,'filled',...
    ani_target_marker,'MarkerEdgeColor',ani_target_marker_color,...
    'MarkerFaceColor',ani_target_marker_color);

%% plot the real robots
hold on;
scatter(p_robots(:,1,1),p_robots(:,2,1),ani_robot_marker_size,'filled',...
    ani_robot_marker,'MarkerEdgeColor',ani_robot_marker_color,...
    'MarkerFaceColor',ani_robot_marker_color);

%% plot the virtual robots
% reshape: n_robots x 2 x pop_sz -> 2 x (n_robots x pop_sz)
pv_robots = reshape(shiftdim(p_robots,1),2,[]);
hold on;
scatter(pv_robots(1,:),pv_robots(2,:),...
    ani_virtual_robot_marker_size,'filled',ani_virtual_robot_marker,...
    'MarkerEdgeColor',ani_virtual_robot_marker_color,...
    'MarkerFaceColor',ani_virtual_robot_marker_color);

%% save the frame
frame = getframe(f.CurrentAxes);
imwrite(frame.cdata, frame_name);

%% cloes figure
close(f);

end