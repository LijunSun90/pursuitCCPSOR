function [pi_robots,pg_robots,fitness_p,fitness_pi,fitness_pg] = ...
    fitness_update(p_target,p_robots,pi_robots,pg_robots,...
                            fitness_p,fitness_pi,fitness_pg,map_w,map_h)
%% fitness_update - 
% 
% DESCRIPTION:
%       Update the fitness, inidividual historical best and global best due
%       to the dynamic environment.
% 
% 
% INPUT:
%       p_target        - position of the target
%                         Matrix: 2 x 1
%       p_robots        - the positions of all the robots 
%                         Matrix: n_robots x n_dim x pop_sz
%       pi_robots       - the individual historical best of p_robots
%                         Matrix: n_robots x n_dim x pop_sz
%       pg_robots       - the global best of each subpopulation
%                         Matrix: n_robots x n_dim
%       fitness_p       - fitness values of p_robots
%                         Matrix: n_robots x 1 x pop_sz
%       fitness_pi      - fitness values of pi_robots
%                         Matrix: n_robots x 1 x pop_sz
%       fitness_pg      - fitness values of pg_robots
%                         Matrix: n_robots x 1
% 
% 
% OUTPUT:
%       pi_robots       - the individual historical best of p_robots
%                         Matrix: n_robots x n_dim x pop_sz
%       pg_robots       - the global best of each subpopulation
%                         Matrix: n_robots x 1
%       fitness_p       - fitness values of p_robots
%                         Matrix: n_robots x 1 x pop_sz
%       fitness_pi      - fitness values of pi_robots. 
%                         Matrix: n_robots x 1 x pop_sz
%       fitness_pg      - fitness values of pg_robots
%                         Matrix: n_robots x 1
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 4, 2018

%% define variables
[n_robots,n_dim,pop_sz] = size(p_robots);

%% re-evaluate the fitness of all individuals
% loop all the subpopulations
for i_robot = 1:n_robots
%     % loop all the individuals in a subpopulation
%     for individual = 1:pop_sz
%         % make a copy of pr_robots and replace
%         pr_robots_tmp = p_robots(:,:,1);
%         pr_robots_tmp(i_robot,:) = p_robots(i_robot,:,individual);
%         
%         % evaluate the fitness
%         fitness_p(i_robot,:,individual) = ...
%             fitness_encircle(pr_robots_tmp,i_robot,p_target,map_w,map_h);
% 
%         % update the individual historical best
%         if fitness_p(i_robot,:,individual) <= fitness_pi(i_robot,:,individual)
%             pi_robots(i_robot,:,individual) = p_robots(i_robot,:,individual);
%             fitness_pi(i_robot,:,individual) = fitness_p(i_robot,:,individual);
%         end
%         % END if fitness_p(i_robot,:,individual) <= fitness_pi(i_robot,:,individual)
% 
%         % update the global best
%         if fitness_p(i_robot,:,individual) <= fitness_pg(i_robot,:)
%             pg_robots(i_robot,:) = p_robots(i_robot,:,individual);
%             fitness_pg(i_robot,:) = fitness_p(i_robot,:,individual);
%         end
%         % END if fitness_p(i_robot,:,individual) <= fitness_pg(i_robot,:)
%     end
%     % END for individual = 1:pop_sz

    % re-evaluate the fitness value of these robots in the subpopulation
    [pi_robots(i_robot,:,:),pg_robots(i_robot,:,:),...
        fitness_p(i_robot,:,:),fitness_pi(i_robot,:,:),...
        fitness_pg(i_robot,:)] =...
                fitness_subpopulation_restart(p_robots(:,:,1),i_robot,...
                    p_robots(i_robot,:,:),fitness_p(i_robot,:,:),...
                    pi_robots(i_robot,:,:),fitness_pi(i_robot,:,:),...
                    p_target,map_w,map_h);
end
% END for i_robot = 1:n_robots

end