function [fitness,fit_closure,fit_expanse,fit_uniformity,NND] = ...
    fitness_encircle_real(pr_robots,p_target,map_w,map_h)
%% fitness_encircle_real - evaluate each fitness part for all real robots
% 
% INPUT:
%       pr_robots       - the positions of all the real robots 
%                         Matrix: n_robots x n_dim
%       p_target        - position of the target
%                         Matrix: 2 x 1
% 
% OUTPUT:
%       fitness         - the evaluated fitness value
%                         Scalar
%       fit_closure     - the closure evaluation part of the fitness
%                         Scalar
%       fit_expanse     - the group expanse evaluation part of the fitness
%                         Scalar
%       fit_uniformity  - the uniformity evaluation part of the fitness
%                         Scalar
%       NND             - nearest neighbor distance for all the robot
%                         Scalar
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 3, 2018

%% define variables
D_MIN = 1;
p = [pr_robots; p_target];
D = pdist(p);
n_robots = size(pr_robots,1);

%% part - closure: the group center is located inside the convex hull
% the convex hull K and the corresponding area/volume V bounded by K
try
    [K,~] = convhull(pr_robots);
catch ME
    %disp(ME);
    if isequal(ME.message,...
           'Error computing the convex hull. The points may be collinear.')
        % points may be collinear
        K = 1:n_robots;
    end
end

% in: 1 - the corresponding query point is inside the polygonal region or 
%         on the edge of the polygon boundary
% in: 0 - the corresponding query point is outside the polygonal region
% on: 1 - the corresponding query point is on the polygon boundary
% on: 0 - the corresponding query point is inside or outside the polygon 
%         boundary
try
    [in, on] = inpolygon(p_target(:,1),p_target(:,2),...
        pr_robots(K,1),pr_robots(K,2));
catch ME
    if isequal(ME.message,...
            ['The results from INPOLYGON may not be reliable. ',...
            'The size of the polygon is approaching the lower limit ',...
            'of what can be handled with reasonable accuracy.'])
        in = false;
        on = false;
    end    
end

% fit_closure in {0, 0.5, 1}
% 
%     |- 0(outside):                              fit_closure = 1
% in -|- 1(inside or on edge): on -|- 1(on edge): fit_closure = 0.5
%                                  |- 0(inside) : fit_closure = 0
fit_closure = (1-in) + in*(on*0.5);

%% part - group expanse
fit_expanse = mean(vecnorm(pr_robots - p_target, 2, 2), 1);

%% part - uniformity
fit_uniformity =uniformity_edges_calculate(pr_robots,p_target,map_w,map_h);

%% collision avaoidance
% nearest neighbor distance for all the robot
NND = min(D);

%% output
fitness = fit_closure + fit_expanse + fit_uniformity;

end