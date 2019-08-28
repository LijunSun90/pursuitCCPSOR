function p_target = init_target_pos2d(map_w, map_h)
%init_target_pos2d - generate 1 target initial position in 2D space
%-------------------------------------------------------------------------
% 
% REFERENCE:
%       None.
% 
% INPUT:
%       map_w       - width of the map
%       map_h       - height of the map
% 
% OUTPUT:
%       p_target    - generated target initial positions, 1x2 matrix
%  
% AUTHOR:
%       Lijun SUN
%-------------------------------------------------------------------------

%% generate 1 target initial position
p_target = round([map_w,map_h]./2);

end