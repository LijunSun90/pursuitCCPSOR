function p_next = ...
    next_desire_move(p_current,p_obstacles,map_w,map_h,dir_desire)
%next_desire_move -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Compute the neighbor @p_next for the next move from the currepnt
%       position @p_current based on the desired direction @dir_desire.
% 
% INPUT:
%       p_current       - the current position
%                         Matrix: 1 x 2 
%       p_obstacles     - the positions of the obstacles
%                         Matrix: n x 2
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
%       dir_desire      - desired direction 
%                         Matrix: 1 x 2
% 
% OUTPUT:
%       p_next          - the next position
%                         Matrix: 1 x 2
%  
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Nov 29, 2018
%-------------------------------------------------------------------------

%% define variables
% the vectors of all the 8 one step away neighbors:
vs_one_step = [1,0; 1,1; 0,1; -1,1; -1,0; -1,-1; 0,-1; 1,-1];     
n_neighbors = size(vs_one_step,1);

increment = [1, -2, 3, -4, 5, -6, 7];
MAX_TRIALS = length(increment);
trial = 1;

%% check inputs
if nargin < 5
    idx = randi(n_neighbors,1);
    dir_desire = vs_one_step(idx,:);
%     trial = trial + 1;
end

%% generate the next position
idx = find(ismember(vs_one_step,dir_desire,'rows') == true);
p_next = p_current + vs_one_step(idx,:);

% check if the new position is out of the range
% check if exist possible collisions
% check if the maximum trials is reached
while ((p_next(1) < 1 || p_next(1) > map_w ...
        || p_next(2) < 1 || p_next(2) > map_h) ...
        || collision_moving(p_current,p_next,p_obstacles))...
        && trial <= MAX_TRIALS 
    % update  the index
    idx = idx + increment(trial);
    if idx == 0 
        idx = 8;
    elseif idx > 8 || idx < 0
        idx = mod(idx+8, 8);
    end
    % END if idx == 0 
    
    % generate new positions
    p_next = p_current + vs_one_step(idx, :);
    
    % update
    trial = trial + 1;     
end
% END while ((p_next(1) < 1 || p_next(1) > map_w ...

%% result
% if tried and there is nowhere to go, then stay still.
if (p_next(1) < 1 || p_next(1) > map_w ...
        || p_next(2) < 1 || p_next(2) > map_h) ...
        || collision_moving(p_current,p_next,p_obstacles)
    p_next = p_current;
end
% END if (p_next(1) < 1 || p_next(1) > map_w ...


end