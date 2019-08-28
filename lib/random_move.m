function p_next = random_move(p_current,p_obstacles,map_w,map_h)
%% random_move -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Randomly find the next neighbor to move to @p_next without 
%       collisions in terms of @p_obstacles. If failed, it will search its  
%       neighbors for the next move which has the minimum angle distance 
%       with its first randomly chosen direction and has no obstacles while
%       moving there.
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
% 
% OUTPUT:
%       p_next          - the next position
%                         Matrix: 1 x 2
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%      Nov 29, 2018
%-------------------------------------------------------------------------

p_next = next_desire_move(p_current,p_obstacles,map_w,map_h);

end