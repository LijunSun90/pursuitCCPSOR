function uniformity = ...
    uniformity_symmetry_calculate(pr_robots,p_target,map_w,map_h)
%% uniformity_symmetry_calculate -
% 
% DESCRIPTION:
%       Calculate the symmetric uniformity.
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
%       uniformity      - uniformity of the group
%                         Scalar
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 6, 2018

%% edges
xedges = [0.5,p_target(1)-0.5,p_target(1)+0.5,map_w+0.5];
yedges = [0.5,p_target(2)-0.5,p_target(2)+0.5,map_h+0.5];

%% bivariate histogram bin counts
[N,~,~,~,~] = ...
    histcounts2(pr_robots(:,1),pr_robots(:,2),xedges,yedges);

%% uniformity
uniformity_diagonal = std([N(1,1),N(3,3),N(3,1),N(1,3)]);
uniformity_axis = std([N(1,2),N(3,2),N(2,1),N(2,3)]);
uniformity = uniformity_diagonal + uniformity_axis;

end