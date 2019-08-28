function pr_robots = swarm_random_move(pr_robots,p_target,map_w,map_h)
%% swarm_random_move -
% 
% DESCRIPTION:
%       Add a random noise to the predators swarm robots such that every
%       real robot randomly move to a neighbor in turn while avoiding the
%       other real robots and the target.
% 
%       Note that each real robot has a certain probability to move and not
%       to move.
% 
% INPUT:
%       pr_robots       - positions of the real robots swarm
%                         Matrix: n_robots x 2
%       p_target        - position of the target
%                         Matrix: 1 x 2
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
% 
% OUTPUT:
%       pr_robots       - positions of the real robots swarm
%                         Matrix: n_robots x 2
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 7, 2018

%% define variables
n_robots = size(pr_robots,1);
prob_move = 0; % 0.5

%% add random noise
for i_robot = 1:n_robots
    % real robot move
    if rand >= prob_move
        p_obstacles = [pr_robots([1:(i_robot-1),(i_robot+1):end], :);...
                       p_target];
        pr_robots(i_robot,:) = next_desire_move(pr_robots(i_robot,:),...
                                                p_obstacles,map_w,map_h);
    end
    % END if rand >= prob_move    
end
% END for i_robot = 1:n_robots

end