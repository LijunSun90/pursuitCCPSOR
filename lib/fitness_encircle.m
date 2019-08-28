function fitness = ...
    fitness_encircle(pr_robots_i_j,i_robot,p_target,map_w,map_h)
%fitness_encircle - evaluate the fitness for the encirclement task
%-------------------------------------------------------------------------
% 
% INPUT:
%       pr_robots_i_j   - the positions of all the real robots with the
%                         position of the ith real robot being replaced by 
%                         the jth (virtual) robot in the ith subpopulation.
%                         Matrix: n_robots x n_dim
%       i_robot         - the index of the subpopulation of the current 
%                         evaluated robot
%                         Scalar
%       p_target        - position of the target
%                         Matrix: 2 x 1
% 
% OUTPUT:
%       fitness         - the evaluated fitness value
%                         Scalar
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 3, 2018
%-------------------------------------------------------------------------

%% define variables
n_robots = size(pr_robots_i_j,1);

D_MIN = 1;
p = [pr_robots_i_j; p_target];
D = pdist(p);

%% part - closure: the group center is located inside the convex hull
% the convex hull K and the corresponding area/volume V bounded by K
try
    [K,~] = convhull(pr_robots_i_j);
catch ME
    %disp(ME);
    if isequal(ME.message,['Error computing the convex hull. ',...
            'The points may be collinear.']) ...
            || isequal(ME.message,['Error computing the convex hull. ',...
            'Not enough unique points specified.'])
        % points may be collinear
        K = 1:n_robots;
    else
        disp('Lijun: errors occur in computing convhull.');
        disp(ME);
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
                         pr_robots_i_j(K,1),pr_robots_i_j(K,2));
catch ME
    if isequal(ME.message,...
            ['The results from INPOLYGON may not be reliable. ',...
            'The size of the polygon is approaching the lower limit ',...
            'of what can be handled with reasonable accuracy.'])
        in = false;
        on = false;
    else
        disp("Lijun: errors occur in computing inpolygon.");
        disp(ME);
    end
end

% fit_closure in {0, 0.5, 1}
% 
%     |- 0(outside):                              fit_closure = 1
% in -|- 1(inside or on edge): on -|- 1(on edge): fit_closure = 0.5
%                                  |- 0(inside) : fit_closure = 0
fit_closure = (1-in) + in*(on*0.5);

%% part - group expanse
% N = vecnorm(A,p,DIM) finds the p-norm along the dimension DIM of A.
fit_expanse = mean(vecnorm(pr_robots_i_j - p_target, 2, 2), 1);

%% part - uniformity
fit_uniformity = uniformity_edges_calculate(pr_robots_i_j,p_target,...
                                            map_w,map_h);

%% collision avaoidance
% collision avoidance function definition
D_square = squareform(D);
D_square(1:( size(p,1) + 1 ):end) = NaN;
% nearest neighbor distance for the ith robot
NND_i = min(D_square(i_robot,:));

% collision avoidance function
if NND_i <= D_MIN
    fit_repel = exp( -2 * (NND_i - D_MIN) );
else 
    fit_repel = 1;
end
% END if NND_i <= D_MIN

%% output
fitness = fit_repel * (fit_closure + fit_expanse + fit_uniformity);

end