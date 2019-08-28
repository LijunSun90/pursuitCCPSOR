function ...
    [p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,v_robots]...
        = optimizer_pso_constrained(p_robots,fitness_p,pi_robots,...
        fitness_pi,pg_robots,fitness_pg,v_robots,w,c1,c2,map_w,map_h,radius)
%% optimizer_pso_constrained -
% 
% DESCRIPTION:
% 
% 
% INPUT:
%       p_robots        - position of all the robots in all subpopulations
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_p       - fitness values of p_robots
%                         Matrix: n_robots x 1 x pop_sz
%       pi_robots       - the individual historical best of p_robots
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_pi      - fitness values of pi_robots
%       pg_robots       - the global best of each subpopulation
%                         Matrix: n_robots x 1
%       fitness_pg      - fitness values of pg_robots
%                         Matrix: n_robots x 1
%       v_robots        - velocity vectors in PSO
%                         Matrix: n_robots x n_dim x pop_sz
%       w               - inertia weight in PSO
%                         Scalar
%       c1              - a constant coefficient in PSO
%                         Scalar
%       c2              - a constant coefficient in PSO
%                         Scalar
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
%       radius          - each subpopulation is distributed in at most the
%                         radius distance awary from its corresponding real
%                         robot
%                         Scalar
%            
% 
% OUTPUT:
%       p_robots        - position of all the robots in all subpopulations
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_p       - fitness values of p_robots
%                         Matrix: n_robots x 1 x pop_sz
%       pi_robots       - the individual historical best of p_robots
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_pi      - fitness values of pi_robots
%       pg_robots       - the global best of each subpopulation
%                         Matrix: n_robots x 1
%       fitness_pg      - fitness values of pg_robots
%                         Matrix: n_robots x 1
%       v_robots        - velocity vectors in PSO
%                         Matrix: n_robots x n_dim x pop_sz
%       
% 
% AUTHOR
%       Lijun SUN
% 
% DATE:
%       August 28, 2018

%% define variables
[n_robots,~,pop_sz] = size(p_robots);

%% loop
% loop all the subpopulations
for i_robot = 1:n_robots
    %% update the current fitness values due to the past changes
    % make a copy of pr_robots and replace
    pr_robots_tmp = p_robots(:,:,1);
    
    % loop
    for individual = 1:pop_sz
        pr_robots_tmp(i_robot,:) = p_robots(i_robot,:,individual);
        
        % evaluate the fitness
        fitness_p(i_robot,:,individual) = ...
            fitness_repel_escape(pr_robots_tmp,i_robot);
        
        % update the individual historical best
        if fitness_p(i_robot,:,individual) < fitness_pi(i_robot,:,individual)
            pi_robots(i_robot,:,individual) = p_robots(i_robot,:,individual);
            fitness_pi(i_robot,:,individual) = fitness_p(i_robot,:,individual);
        end
        % END if fitness_p(i_robot,:,individual) < fitness_pi(i_robot,:,individual)
        
        % update the global best
        if fitness_p(i_robot,:,individual) < fitness_pg(i_robot,:)
            pg_robots(i_robot,:) = p_robots(i_robot,:,individual);
            fitness_pg(i_robot,:) = fitness_p(i_robot,:,individual);
        end
        % END if fitness_p(i_robot,:,individual) < fitness_pg(i_robot,:)
    end
    % END for individual = 1:pop_sz
    
    %% loop all the virtual individuals in a subpopulation
    for individual = 2:pop_sz
        %% generate the new generation
        
        % calculate velocity
        v_robots_new = ...
            w * v_robots(i_robot,:,individual) ...
            + c1*rand()*(pi_robots(i_robot,:,individual) - p_robots(i_robot,:,individual))...
            + c2*rand()*(pg_robots(i_robot,:) - p_robots(i_robot,:,individual));

        % modify the format of v_robots_new
        v_robots_new = one_step_direction(v_robots_new);

        % calculate position
        p_robots_new = p_robots(i_robot,:,individual) + v_robots_new;
        
        % restrict the position of each virtual robot to a fixed radius of
        % the real robots
        p_robots_new = ...
            within_scope( p_robots_new,p_robots(i_robot,:,1),radius );
        
        %% fitness evaluation
        % make a copy of pr_robots and replace
        pr_robots_tmp = p_robots(:,:,1);
        pr_robots_tmp(i_robot,:) = p_robots_new;
        
        % evaluate the fitness
        fitness_p_new = fitness_repel_escape(pr_robots_tmp,i_robot);
        
        %% check if it is in the valid range
        if p_robots_new(1) <= map_w ...
                && p_robots_new(1) >= 0 ...
                && p_robots_new(2) <= map_h ...
                && p_robots_new(2) >= 0
            valid_range = true;
        else
            valid_range = false;
        end
        % END if p_robots_new <= map_w

        %% Generation update
        if fitness_p_new < fitness_p(i_robot,:,individual) && valid_range            
            p_robots(i_robot,:,individual) = p_robots_new;
            fitness_p(i_robot,:,individual) = fitness_p_new;
            v_robots(i_robot,:,individual) = v_robots_new;
            
            % update individual historical best
            if fitness_p_new < fitness_pi(i_robot,:,individual)
                pi_robots(i_robot,:,individual) = p_robots_new;
                fitness_pi(i_robot,:,individual) = fitness_p_new;
            end
            % END if fitness_p_new < fitness_pi(i_robot,:,individual)
            
            % update the global best
            if fitness_p_new < fitness_pg
                pg_robots(i_robot,:) = p_robots_new;
                fitness_pg(i_robot,:) = fitness_p_new;
            end
            % END if fitness_p_new < fitness_pg
            
        end
        % END if fitness_p_new < fitness_p(i_robot,:,individual)
    end
    % END for individual = 2:pop_sz
    
    
    %% loop the real robot in the subpopulation
    %% generate the new generation
    % calculate velocity
    v_robots_new = ...
        w * v_robots(i_robot,:,1) ...
        + c2*rand()*(pg_robots(i_robot,:) - p_robots(i_robot,:,1));

    % modify the format of v_robots_new
    v_robots_new = one_step_direction(v_robots_new);

    % calculate position
    p_robots_new = p_robots(i_robot,:,1) + v_robots_new;
    
    %% fitness evaluation
    % make a copy of pr_robots and replace
    pr_robots_tmp = p_robots(:,:,1);
    pr_robots_tmp(i_robot,:) = p_robots_new;

    % evaluate the fitness
    fitness_p_new = fitness_repel_escape(pr_robots_tmp,i_robot);    
    
    %% check if it is in the valid range
    if p_robots_new(1) <= map_w ...
            && p_robots_new(1) >= 0 ...
            && p_robots_new(2) <= map_h ...
            && p_robots_new(2) >= 0
        valid_range = true;
    else
        valid_range = false;
    end
    % END if p_robots_new <= map_w
    
    %% Generation update
    if fitness_p_new < fitness_p(i_robot,:,1) && valid_range
        p_robots(i_robot,:,1) = p_robots_new;
        fitness_p(i_robot,:,1) = fitness_p_new;
        v_robots(i_robot,:,1) = v_robots_new;

            
        % update the global best
        if fitness_p_new < fitness_pg
            pg_robots(i_robot,:) = p_robots_new;
            fitness_pg(i_robot,:) = fitness_p_new;
        end
        % END if fitness_p_new < fitness_pg
    end
    % END if fitness_p_new < fitness_p(i_robot,:,individual)
end
% END for i_robot = 1:n_robots

end