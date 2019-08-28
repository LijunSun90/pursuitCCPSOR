function escape_dirs = escape_line_choose(pr_robots,p_target,map_w,map_h)
%escape_line_choose - 
%-------------------------------------------------------------------------
% 
% DESCRIPTION:
%       Choose one of the eight directions (north, north east, east, south
%       east, south, south west, west, north west) as the escpae direction,
%       in which the target will keep on esacping from predator robots in
%       ALMOST A STRAIGHT LINE.
% 
%       These directions are selected such that in that direction there is
%       minimum predator robots. This is quantified as the historgram
%       counts.
%       At the same time, it has the longest path for the target to move
%       among the escape paths that have the same number of predators.
%       This is quantified as the "life" indicator.
% 
%       Historigram counts result:
%       origin --> y
%       | [ N_11, N_12, N_13 ]
%       V [ N_21, N_22, N_23 ]
%       x [ N_31, N_32, N_33 ]
% 
%       Map coordinations:
%       map_h
%       y -|-|-|-|-|-|-|-|-
%       ^ -|-|-|-|-|-|-|-|-
%       | -|-|-|-|-|-|-|-|-
%       origin --> x map_w
% 
%       Historigram counts result reflected on the map:
%       map_h
%       y N_13, N_23, N_33
%       ^ N_12, N_22, N_32
%       | N_11, N_21, N_31
%       origin --> x map_w
% 
%       Possible escape directions:
%       y (-1,1),  (0,1),  (1,1)
%       ^ (-1,0),  (0,0),  (1,0)
%       | (-1,-1), (0,-1), (1,-1)
%       origin --> x 
% 
%       Possible escape directions:
%       y north west, north, north east
%       ^ west,       here,  east
%       | south west, south, south east
%       origin --> x  
% 
% 
% INPUT:
%       pr_robots       - positions of the real robots
%                         Matrix: n_robots x n_dim x 1
%       p_target        - position of the target
%                         Matrix: 1 x n_dim
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
% 
% OUTPUT:
%       escape_dirs     - escape directions in the descending order in
%                         terms of the "life" indicator defined in the
%                         codes. (The longer "life", the better.)
%                         Matrix: n_dirs x 2
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Nov 19, 2018
%-------------------------------------------------------------------------

%% define variables
% 8 neighbors
possible_dirs = { [-1,1],  [0,1],  [1,1];...
                  [-1,0],  [0,0],  [1,0];...
                  [-1,-1], [0,-1], [1,-1]};
% possible_dirs = { [1,1],  [1,0],  [1,-1];...
%                   [0,1],  [0,0],  [0,-1];...
%                   [-1,1], [-1,0], [-1,-1]}; 

% 4 neighbors
% possible_dirs = {[1,0]; [0,1]; [-1,0]; [0,-1]};
            
%% define life
% life: the predicted maximum steps the target can move in that direction
life_west = p_target(1) - 1;
life_east = map_w - p_target(1);
life_north = map_h - p_target(2);
life_south = p_target(2) - 1;
% 8 neighbors
life_dirs = ...
    [sqrt(life_west^2 + life_north^2), life_north, ...
     sqrt(life_north^2 + life_east^2);...
    life_west, NaN, life_east;...
    sqrt(life_west^2 + life_south^2), life_south, ...
    sqrt(life_south^2 + life_east^2)];

% 4 neighbors
% life_dirs = [life_east; life_north; life_west; life_south];

%% edges
xedges = [0.5,p_target(1)-0.5,p_target(1)+0.5,map_w+0.5];
yedges = [0.5,p_target(2)-0.5,p_target(2)+0.5,map_h+0.5];

%% bivariate histogram bin counts
[N,~,~,~,~] = histcounts2(pr_robots(:,1),pr_robots(:,2),xedges,yedges);

%% data post-processing
N = rot90(N);
N(2,2) = NaN;

%% if the target is on an edge, then it don't move towards that edge
if p_target(1) == 1
    N(:,1) = ones(3,1) .* NaN;
elseif p_target(1) == map_w
    N(:,3) = ones(3,1) .* NaN;
end

if p_target(2) == 1
    N(3,:) = ones(1,3) .* NaN;
elseif p_target(2) == map_h
    N(1,:) = ones(1,3) .* NaN;
end

% 4 neighbors
% N = [N(2,3);N(1,2);N(2,1);N(3,2)];

%% determine the indices based on the historgram counts
N_min = min(min(N));
idx = find(N == N_min);

%% re-order the indices based on the life
life_selected = life_dirs(idx);
[~,idx_descending] = sort(life_selected,'descend');
idx = idx(idx_descending);

%% select espace direction in which there are least robots
n_dirs = length(idx);
escape_dirs = zeros(n_dirs,2);
for k = 1:n_dirs
    index = idx(k);
    escape_dirs(k,:) = possible_dirs{index};
end
% END for k = 1:n_dirs

%% debug
% disp("N = " + num2str(N));
% disp("escape_dirs = " + num2str(escape_dirs));

end