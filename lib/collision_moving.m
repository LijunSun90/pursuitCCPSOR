function collision = collision_moving(p_from,p_to,p_obstacles)
%collision_moving - check whether exist collision while moving
%-------------------------------------------------------------------------
% INPUT:
%       p_from          - the position where the robot from
%                         Matrix: 1 x n_dim
%       p_to            - the position where the robot go to
%                         Matrix: 1 x n_dim
%       p_obstacles     - positions of the obstacles
%                         Matrix: n_robots x n_dim
% 
% 
% OUTPUT:
%       collision       - true: collide; false: no collision
%   
% 
% AUTHOR:
%     Lijun SUN
%-------------------------------------------------------------------------

%% check if exist collision after the robot moved
D = pdist([p_obstacles; p_to]);
D_min = min(D);
% 
if D_min == 0
    collision_moved = true;
else
    collision_moved = false;
end
% END if D_min == 0

%% check if exist obstacles in the path during the robot moving diagonally
% initialization
collision_moving = false;

% check if exist collision when the robot is moving diagonally
if isequal( abs(p_to - p_from), [1,1] )
    p_obstacle_1 = [p_from(1), p_to(2)];
    p_obstacle_2 = [p_to(1), p_from(2)];
    
    if ismember(p_obstacle_1,p_obstacles,'rows')...
            || ismember(p_obstacle_2,p_obstacles,'rows')
        collision_moving = true;
    end
    % END ismember(p_obstacle_1,p_obstacles,'rows')
end
% END if isequal( abs(p_to - p_from), [1,1] )

%% output the result
if collision_moved || collision_moving
    collision = true;
else
    collision = false;
end
% END if collision_moved || collision_moving

end