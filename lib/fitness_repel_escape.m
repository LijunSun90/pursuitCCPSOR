function fitness = fitness_repel_escape(pr_robots_i_j,i_robot)
%% fitness_repel_escape - evaluate the NND based fitness value
% 
% INPUT:
%       pr_robots_i_j   - the positions of all the real robots with the
%                         position of the ith real robot being replaced by 
%                         the jth (virtual) robot in the ith subpopulation.
%                         Matrix: n_robots x n_dim x 1
%       i_robot         - the index of the subpopulation of the current 
%                         evaluated robot
%                         Scalar
% 
% OUTPUT:
%       fitness         - the evaluated fitness value
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       August 27, 2018

%% define variables
D_MIN = 2;

%% core
D = pdist(pr_robots_i_j);
D_square = squareform(D);
D_square(1:( size(pr_robots_i_j,1) + 1 ):end) = NaN;
% nearest neighbor distance for the ith robot
NND_i = min(D_square(i_robot,:));
fit_repel = exp( -2*(NND_i-D_MIN) );

%% output
fitness = fit_repel;

end