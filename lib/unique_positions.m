function p_out = unique_positions(p_in,p_max,p_min,p_target)
%unique_positions - get unique integer positions based on @p_in in the  
%                     range [@p_min, @p_max] considering @p_target
%-------------------------------------------------------------------------
% 
% INPUT:
%     p_in        - initial positions of the real robots. 
%                   Matrix of Intergers: n_robots x n_dim x 1
%     p_max       - maximum of the solution space of position p_robots
%                   Matrix: 1 x n_dim
%     p_min       - minimum of the solution space of position p_robots
%                   Matrix: 1 x n_dim
%     p_target    - position of the target
%                   Matrix: 1 x 2
% 
% OUTPUT:
%     p_out       - unique positions of robots whose values are integers.
%                   Matrix of Intergers: n_robots x n_dim x 1
% 
% AUTHOR:
%     Lijun SUN
%-------------------------------------------------------------------------

%% check input parameters
if nargin < 4
    p_target = [0,0];
end
% END if nargin < 4

%% define variables
n_robots = size(p_in,1);
n_dim = size(p_in,2);
n_target = size(p_target,1);

%% 
% loop
p_in_target = [p_in; p_target];
[p_in_target_tmp,idx_unique,~] = unique(p_in_target,'rows','stable');
n_rand = n_robots;
while length(idx_unique) < (n_robots + n_target)
    % update
    n_rand = 2*n_rand;
    
    % re-calculate
    p_in = round( (p_max - p_min) .* rand([n_rand,n_dim]) + p_min );
    p_in_target = [p_in; p_target];
    [p_in_target_tmp,idx_unique,~] = unique(p_in_target,'rows','stable');
end
% END while length(idx_unique) < n_robots

%% output
p_out = p_in_target_tmp(1:n_robots,:);

end