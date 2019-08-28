function p_robots_i =...
    virtual_robots_redistribute(pr_robots_i,pop_sz,radius,map_w,map_h)
%virtual_robots_redistribute -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Redistribute the virtual robots to the limited neighborhood of the
%       real robot.
% 
% INPUT:
%       pr_robots_i     - position of the real robot in the ith 
%                         subpopulation
%                         Matrix: 1 x n_dim
%       pop_sz          - population size of the subpopulation
%                         Scalar
%       radius          - the radius around the real robot within which  
%                         the virtual robots are allowed to be distributed
%                         Scalar
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
% 
% OUTPUT:
%       p_robots_i      - positions of all the robots in the ith
%                         subpopulation
%                         Matrix: 1 x n_dim x pop_sz
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 7, 2018
%-------------------------------------------------------------------------

%% define variables
n_dim = size(pr_robots_i,2);
x_min = ones(pop_sz, 1);
x_max = map_w .* ones(pop_sz, 1);
y_min = ones(pop_sz, 1);
y_max = map_h .* ones(pop_sz, 1);

%% initialize the positions of virtual robots
% random in (-1,1)
p_robots_i = 2.*rand([1, n_dim, pop_sz]) - 1;

% rescale to the radius extent around the center pr_robots_i
p_robots_i = radius .* p_robots_i + pr_robots_i;

% require the values are integers.
p_robots_i = round(p_robots_i);

% ensure all the virtual robots are in the valid range
p_robots_i(1,1,:) = max([x_min, squeeze(p_robots_i(1,1,:))], [], 2);
p_robots_i(1,1,:) = min([x_max, squeeze(p_robots_i(1,1,:))], [], 2);
p_robots_i(1,2,:) = max([y_min, squeeze(p_robots_i(1,2,:))], [], 2);
p_robots_i(1,2,:) = min([y_max, squeeze(p_robots_i(1,2,:))], [], 2);

% recover the real robots' positions
p_robots_i(:,:,1) = pr_robots_i;


%% Debug
% disp("After redistributing, unique virtual robots are:");
% p_robots_i_tmp = squeeze(p_robots_i(1,:,2:end));
% disp( length(unique(p_robots_i_tmp.','rows','stable')) );

end