function captured = ...
    capture_occupy(p_target_last, pr_robots_last, p_target_current)
% ------------------------------------------------------------------------
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Sep 12, 2019
% ------------------------------------------------------------------------

%% define variables.
n_robots = size(pr_robots_last, 1);

%% obtain common neighbors set.
neighbor_offset_horizontal = [1, 0];
neighbor_offset_vertical = [0, 1];
neighbor_diagnoal = [1, 1];
common_neighbors = zeros([2*n_robots, 2]);
exist_neighbor = false;
for idx_hunter = 1 : n_robots
    p_offset = abs(p_target_last - pr_robots_last(idx_hunter, :));
    common_neighbor_offsets = zeros([2,2]) + inf;
    if isequal(p_offset, neighbor_offset_horizontal)
        common_neighbor_offsets = [0, 1; 0, -1];
        exist_neighbor = true;
    elseif isequal(p_offset, neighbor_offset_vertical)
        common_neighbor_offsets = [-1, 0; 1, 0];
        exist_neighbor = true;
    elseif isequal(p_offset, neighbor_diagnoal)
        common_neighbor_offsets = ...
            [pr_robots_last(idx_hunter,1) - p_target_last(:,1), 0; ...
            0, pr_robots_last(idx_hunter,2) - p_target_last(:,2)];
        exist_neighbor = true;
    end
    % END if isequal(p_offset, neighbor_offset_horizontal)
    idx_1 = (idx_hunter - 1) * 2 + 1;
    idx_2 = idx_1 + 1;
    common_neighbors([idx_1, idx_2], :) = ...
        p_target_last + common_neighbor_offsets;
end
% END for idx_hunter = 1 : n_robots

%% check whether p_target_last is a neighbor of any predator in pr_robots.
captured = false;
if ismember(p_target_current, common_neighbors, 'rows') || ...
        (isequal(p_target_current, p_target_last) && exist_neighbor)
    captured = true;
end
% END if ismember(p_target_current, common_neighbors)

end