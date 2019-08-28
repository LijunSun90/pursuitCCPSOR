function [pi_robots_i,pg_robots_i,fitness_p_i,fitness_pi_i,fitness_pg_i]...
    = fitness_subpopulation_restart(pr_robots,i_robot,p_robots_i,...
                                    fitness_p_i_last,pi_robots_i,...
                                    fitness_pi_i,p_target,map_w,map_h)
%fitness_subpopulation_restart -
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Restart the fitness evaluation of the ith subpopulation.
%  
% INPUT:
%       pr_robots        - position of all the real robot
%                          Matrix: n_robots x n_dim
%       i_robot          - the index of the current subpopulation in all the
%                          subpopulations
%                          Scalar
%       p_robots_i       - positions of all the robots in the ith
%                          subpopulation
%                          Matrix: 1 x n_dim x pop_sz
%       fitness_p_i_last - the fitness values of the robots in the ith
%                          subpopulation in the last moment
%                          Matrix: 1 x 1 x pop_sz
%       pi_robots_i      - the individual historical best of each robot in
%                          the ith subpopulation
%                          Matrix: n_dim x pop_sz
%       fitness_pi_i     - the individual historical best fitness values of
%                          the robots in the ith subpopulation
%                          Matrix: 1 x 1 x pop_sz
%       p_target         - position of the target
%                          Matrix: 1 x n_dim
% 
% OUTPUT:
%       pi_robots_i      - the individual historical best of each robot in
%                          the ith subpopulation
%                          Matrix: n_dim x pop_sz
%       pg_robots_i      - the global best one in the ith subpopulation
%                          Matrix: 1 x 1 x n_dim
%       fitness_p_i      - the fitness values of the robots in the ith
%                          subpopulation
%                          Matrix: 1 x 1 x pop_sz
%       fitness_pi_i     - the individual historical best fitness values of
%                          the robots in the ith subpopulation
%                          Matrix: 1 x 1 x pop_sz
%       fitness_pg_i     - the fitness value of the global best individual 
%                          in the ith subpopulation
%                          Scalar
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 7, 2018
%-------------------------------------------------------------------------

%% define variables
[~,~,pop_sz] = size(p_robots_i);
% 0.95; -1(0), totally inherit; 1, totally not inherit
THRESHOLD_CHANGE = 1;

%% get the fitness
fitness_p_i = zeros(1,1,pop_sz);

for individual = 1:pop_sz
    % make a copy of pr_robots and replace
    pr_robots_tmp = pr_robots;
    pr_robots_tmp(i_robot,:) = p_robots_i(:,:,individual);

    % evaluate the fitness
    fitness_p_i(:,:,individual)=fitness_encircle(pr_robots_tmp,i_robot,...
                                                 p_target,map_w,map_h);
                                             
    % evaluate the changes in the dynamic environment
    % h_change = 1  =>  no change;
    % h_change -> 0 =>  change is large;
    % h_change -> 1 =>  change is small.
    h_change = ...
        min(fitness_p_i_last(:,:,individual),fitness_p_i(:,:,individual))...
        /max(fitness_p_i_last(:,:,individual),fitness_p_i(:,:,individual));
    % change is large
    if h_change <= THRESHOLD_CHANGE
        inherit = false;
    else
        inherit = true;
    end
    % END if h_change < THRESHOLD_CHANGE
                                             
    % get the individual historical best
    if inherit ...
            && fitness_p_i(:,:,individual) <= fitness_pi_i(:,:,individual)
        fitness_pi_i(:,:,individual) = fitness_p_i(:,:,individual);
        pi_robots_i(:,:,individual) = p_robots_i(:,:,individual);
    end
    % END if fitness_p_i(:,:,individual) <= fitness_pi_i
end
% END for individual = 1:pop_sz

%% get the individual historical best and the corresponding fitness values
% NOTE that the individual historical best memories @pi_robots_i and 
% @fitness_pi_i are not inherited in solving this dynamic optimization 
% problem.
if ~inherit
    pi_robots_i = p_robots_i;
    fitness_pi_i = fitness_p_i;
end
% END if ~inherit

%% initialize the global best individual (particle) and get the fitness_pg
[fitness_pg_i,idx_pg_i] = min(fitness_p_i);
pg_robots_i = p_robots_i(:,:,idx_pg_i);  

end