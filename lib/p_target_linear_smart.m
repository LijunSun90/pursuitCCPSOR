function [p_target_next,escape_dirs] = ...
    p_target_linear_smart(p_target,pr_robots,map_w,map_h,escape_dirs)
%% p_target_linear_smart - update the target's position in a line smartly
% DESCRIPTION:
%       Update the target's position such that it can escape from the
%       predator robots in almost a straight line, the direction of which
%       is determined by the parameter @escape_dirs.
% 
%       The move direction of the target is first assigned as the first row
%       of @escape_dirs, which is best among all the rows of @escape_dirs.
%       If this direction may occur collision with other robots, then the
%       direction is assigned as the nearest neighbor that has the minimum
%       angle distance with the desired escape direction. And it can be
%       represented as follows:
%       [+1,-1,+2,-2,+3,-3,+4] 
% 
%       The neighbors is numbered as follows:
%       4   3   2
%       5   *   1
%       6   7   8
% 
% 
% INPUT:
%       p_target        - current position of the target
%                       - Matrix: 1 x n_dim
%       pr_robots       - positions of the real robots
%                         Matrix: n_robots x n_dim
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
%       escape_dirs     - escape directions in the descending order in
%                         terms of the "life" indicator defined in the
%                         codes "escape_line_choose.m". (The longer "life",
%                         the better.)
%                         Matrix: n_dirs x 2
% 
% 
% OUTPUT:
%       p_target_next   - next position of the target
%       escape_dirs     - escape directions in the descending order in
%                         terms of the "life" indicator defined in the
%                         codes "escape_line_choose.m". (The longer "life",
%                         the better.) 
%                         Matrix: n_dirs x 2
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% 
% DATE:
%       Nov 21, 2018

%% define variables
escape_dir = escape_dirs(1,:);

%% pre-processing
% if the target is on the edge, re-evaluate the environment and
% re-calculate the escape direction @escape_dirs
if p_target(1) == 1 || p_target(1) == map_w ...
        || p_target(2) == 1 || p_target(2) == map_h
    escape_dirs = escape_line_choose(pr_robots,p_target,map_w,map_h);
    escape_dir = escape_dirs(1,:);
    
    % debug
%     disp("Newly calculated escape_dirs = " + mat2str(escape_dirs));
end
% END if p_target(1) == 1 || p_target(1) == map_w ...

%% generate a new target's position one step away from the current one.
p_target_next = ...
    next_desire_move(p_target,pr_robots,map_w,map_h,escape_dir);

end