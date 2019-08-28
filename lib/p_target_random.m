function p_target_next = p_target_random(p_target,pr_robots,map_w,map_h)
%% p_target_random - randomly update the target's position
% 
% DESCRIPTION:
%       Randomly choose a neighbor as the next destination. If that chosen
%       neighbor is not accessible, for example there is obstacles while
%       moving there, then another random chose is start until the maximum
%       random trials are reached.
% 
% INPUT:
%       p_target        - current position of the target
%                       - Matrix: 1 x n_dim
%       pr_robots       - positions of the real robots
%                         Matrix: n_robots x n_dim
%       map_w           - width of the map
%       map_h           - height of the map
% 
% OUTPUT:
%       p_target_next   - next position of the target
% 
% AUTHOR:
%       Lijun SUN

%% define variables
MAX_TRIALS = 30;
trial = 0;

%% the vectors of all the one step away neighbors:
% 8 neighbors
vs_one_step = [1,0; 1,1; 0,1; -1,1; -1,0; -1,-1; 0,-1; 1,-1];
% 4 neighbors
% vs_one_step = [1,0; 0,1; -1,0; 0,-1];

%% generate a new target's position one step away from the current one.
n_neighbors = size(vs_one_step, 1);
idx = randi(n_neighbors);
p_target_next = p_target + vs_one_step(idx, :);

% check if the new position is out of the range
% check if exist possible collisions
% check if the maximum trials is reached
while (p_target_next(1) < 1 || p_target_next(1) > map_w ...
        || p_target_next(2) < 1 || p_target_next(2) > map_h) ...
        || collision_moving(p_target,p_target_next,pr_robots)...
        && trial < MAX_TRIALS
    % update
    trial = trial + 1;
    
    % generate new positions
    idx = randi(n_neighbors);
    p_target_next = p_target + vs_one_step(idx, :);
end
% END while()

%% result
% if tried and there is nowhere to go, then stay still.
if (p_target_next(1) < 1 || p_target_next(1) > map_w ...
        || p_target_next(2) < 1 || p_target_next(2) > map_h) ...
        || collision_moving(p_target,p_target_next,pr_robots)
    p_target_next = p_target;
end
% END if (p_next(1) < 1 || p_next(1) > map_w ...

end