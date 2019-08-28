function ...
    [p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,...
    v_robots,radius] = ...
    init_cc_pso_constrained_robots(n_robots,n_dim,pop_sz,p_max,p_min,p_target)
%% init_cc_pso_constrained_robots - initilization of the PSO parameters
% 
% DESCRIPTION:
%     There are @n_robots subpopulations. The first individual of each
%     subpopulation corresponds to the real robot in the map. And the
%     individuals whose indexes greater than 2 in each subpopulation are 
%     virtual robots.
% 
%     1. First, the initial positions of the real robots are generaed.
%     2. Then, the initial positions of the virtual robots are generated
%     within a fixed distance to the real robots, so called constrained.
%     The distance is calculated based on the subpopulation size.
% 
% 
% REFERENCE:
%     Shi, Yuhui, and Russell Eberhart. "A modified particle swarm 
%     optimizer." In Evolutionary Computation Proceedings, 1998. IEEE 
%     World Congress on Computational Intelligence., The 1998 IEEE 
%     International Conference on, pp. 69-73. IEEE, 1998.
% 
% 
% INPUT:
%     n_robots    - number of the robots, Scalar
%     n_dim       - dimension of position space, such as 2 for 2D. Scalar
%     pop_sz      - size of the population, Scalar
%     p_max       - maximum of the solution space of position p_robots
%                   Matrix: 1 x n_dim
%     p_min       - minimum of the solution space of position p_robots
%                   Matrix: 1 x n_dim
%     p_target    - position of the target
%                   Matrix: 1 x 2
% 
% 
% OUTPUT:
%     p_robots     - initial positions of robots whose values are integers. 
%                    Matrix of Intergers: n_robots x n_dim x pop_sz
%     fitness_p    - initial fitness of p_robot
%                    Matrix of Intergers: 30 x 1 x pop_sz
%     pi_robots    - the best previous positions of any robots
%                    (individual)
%                    Matrix of Intergers: n_robots x n_dim x pop_sz
%     fitness_pi   - initial fitness of pi_robot
%                    Matrix of Intergers: 30 x 1 x pop_sz
%     pg_robots    - the best positions among all the positions in the
%                    population.
%                    Matrix of Intergers: n_robots x n_dim
%     fitness_pg   - initial fitness of pg_robots
%                    Matrix of Intergers: n_robots x 1
%     v_robots     - the velocity (rate of the position change) 
%                    Matrix of Intergers: n_robots x n_dim x pop_sz
%     radius       - the radius around the real robots within which the 
%                    virtual robots are allowed to be distributed
%                    Scalar
% 
% 
% AUTHOR:
%     Lijun SUN, Chao LYU
% 
% 
% DATE:
%     September 3, 2018

%% check input parameters
if nargin < 6
    p_target = [0,0];
end
% END if nargin < 6

%% initialize the positions of real robots
% random in (0,1)
pr_robots = rand([n_robots, n_dim, 1]);

% rescale
pr_robots = (p_max - p_min) .* pr_robots + p_min;

% require the values are integers.
pr_robots = round(pr_robots);

% generate unique real robots positions
pr_robots = unique_positions(pr_robots,p_max,p_min,p_target);


%% calculate the radius based on the @pop_sz of each subpopulation
radius = radius_calculate(pop_sz);


%% initialize the positions of virtual robots
% random in (-1,1)
p_robots = 2*rand([n_robots, n_dim, pop_sz]) - 1;

% rescale
p_robots = radius .* p_robots + pr_robots;

% require the values are integers.
p_robots = round(p_robots);

% recover the real robots' positions
p_robots(:,:,1) = pr_robots;


%% get the fitness_p
fitness_p = zeros(n_robots,1,pop_sz);

% loop all the subpopulations
for i_robot = 1:n_robots
    % loop all the individuals in a subpopulation
    for individual = 1:pop_sz
        % make a copy of pr_robots and replace
        pr_robots_tmp = pr_robots;
        pr_robots_tmp(i_robot,:) = p_robots(i_robot,:,individual);
        
        % evaluate the fitness
        fitness_p(i_robot,:,individual) = ...
            fitness_repel_escape(pr_robots_tmp,i_robot);
    end
    % END for individual = 1:pop_sz
end
% END for i_robot = 1:n_robots


%% initialize the individual historical best record
pi_robots = p_robots;


%% get the fitness_pi
fitness_pi = fitness_p;


%% initialize the best global individual (particle) and get the fitness_pg
[fitness_pg,idx_pg] = min(fitness_p(1,:,:));
pg_robots = p_robots(:,:,idx_pg);
for i_robot = 1:n_robots
    [fitness_pg(i_robot,:),idx_pg] = min(fitness_p(i_robot,:,:));
    pg_robots(i_robot,:) = p_robots(i_robot,:,idx_pg);  
end
% END for i_robot = 1:n_robots


%% initialize the velocities
% random in (0,1)
% v_robots = rand([pop_sz, n_robots*n_dim]);
v_robots = rand([n_robots, n_dim, pop_sz]);

% modify the format of v_robots
for i_robot = 1:n_robots
    v_robots(i_robot,:,:) = one_step_direction(v_robots(i_robot,:,:));
end
% END for i_robot = 1:n_robots

end