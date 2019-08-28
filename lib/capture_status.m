function captured = capture_status(p_target,pr_robots,map_w,map_h)
%% capture_status -
% 
% DESCRIPTION:
%       Return the capture status of the target:
%       - true if every capture position is out of the map range or is   
%         occupied by a real robot such that the target has nowhere to go.
% 
%       Definition of the capture position (represented as "*"):
%               - * -
%               * & *
%               - * -
% 
% 
% INPUT:
%       p_target           - the position of the target
%                            Matrix: 1 x 2
%       pr_robots          - the positions of the real robot swarm
%                            Matrix: n x 2
%       map_w              - width of the map
%                            Scalar
%       map_h              - height of the map
%                            Scalar
%  
% OUTPUT:
%       captured           - the capture status of the target
%                            true: captured; false: not captured
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 4, 2018

%% define variables
n_robots = size(pr_robots,1);
vs_one_step = [1,0; 1,1; 0,1; -1,1; -1,0; -1,-1; 0,-1; 1,-1];
captured = true;

%% capture status examination
for idx = 1:2:length(vs_one_step)
    p_obstacle = p_target + vs_one_step(idx,:);
    
    % capture status is true if the corresponding capture position is out
    % of range or is occupied by a real robot
    if p_obstacle(1) < 1 || p_obstacle(1) > map_w ...
            || p_obstacle(2) < 1 || p_obstacle(2) > map_h ...
            || ismember(p_obstacle,pr_robots,'rows')
        captured = captured && true;
    else
        captured = captured && false;
    end
    % END if p_obstacle(1) < 1 || p_obstacle(1) > map_w ...
end
% END for idx = 1:2:length(vs_one_step)

end