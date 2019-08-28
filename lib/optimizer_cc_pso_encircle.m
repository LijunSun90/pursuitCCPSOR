function ...
    [p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,...
    v_robots,iters_still]...
        = optimizer_cc_pso_encircle(p_robots,fitness_p,pi_robots,...
        fitness_pi,pg_robots,fitness_pg,v_robots,w,c1,c2,map_w,map_h,...
        radius,p_target,iters_still,captured)
%optimizer_cc_pso_encircle -
%-------------------------------------------------------------------------
% 
% DESCRIPTION:
%       Evolve each individual (robot) in each subpopulation using PSO.
% 
% INPUT:
%       p_robots        - position of all the robots in all subpopulations
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_p       - fitness values for individuals in p_robots
%                         Matrix: n_robots x 1 x pop_sz
%       pi_robots       - the individual historical best of p_robots
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_pi      - fitness values of individuals in pi_robots
%                         Matrix: n_robots x 1 x pop_sz
%       pg_robots       - the global best of each subpopulation
%                         Matrix: n_robots x 1
%       fitness_pg      - fitness values of individuals in pg_robots
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
%                         radius distance awary from its corresponding 
%                         real robot
%                         Scalar
%       p_target        - position of the target
%                         Matrix: 1 x 2
%       iters_still     - number of iterations of the real robot keeping 
%                         still
%                         Scalar
%       captured        - the capture status of the target
%                         true: captured; false: not captured
%            
% OUTPUT:
%       p_robots        - position of all the robots in all subpopulations
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_p       - fitness values for individuals in p_robots
%                         Matrix: n_robots x 1 x pop_sz
%       pi_robots       - the individual historical best of p_robots
%                         Matrix: n_robots x n_dim x pop_sz
%       fitness_pi      - fitness values of individuals in pi_robots
%                         Matrix: n_robots x 1 x pop_sz
%       pg_robots       - the global best of each subpopulation
%                         Matrix: n_robots x 1
%       fitness_pg      - fitness values of individuals in pg_robots
%                         Matrix: n_robots x 1
%       v_robots        - velocity vectors in PSO
%                         Matrix: n_robots x n_dim x pop_sz
%       iters_still     - number of iterations of the real robot keeping 
%                         still
%                         Scalar
%       
% AUTHOR
%       Lijun SUN
% 
% DATE:
%       September 3, 2018
%-------------------------------------------------------------------------

%% define variables
[n_robots,~,pop_sz] = size(p_robots);

% if the number of unique virtual robots in a subpopulation go below this 
% THRESHOLD, they will be redistributed
UNIQUE_VIRTUAL = 9;

% number of iterations for no changes of the real robot
MAX_ITERS_STILL = 5;

% offset from the prey robot to its capture positions
offsets_capture = [1,0;0,1;-1,0;0,-1];

%% loop
% loop all the subpopulations
for i_robot = 1:n_robots  
    %% if the prey has already been captured, this subpopulation won't move
    if captured 
        p_captures = offsets_capture + p_target;
        if ismember(p_robots(:,:,1),p_captures,'rows')
            continue;
        end
        % END if ismember(p_robots(:,:,1),p_captures,'rows')
    end
    % END if captured 
    
    %% update the current fitness values due to the past changes: shuffle  
    % re-evaluate the fitness value of these robots in the subpopulation
    [pi_robots(i_robot,:,:),pg_robots(i_robot,:,:),...
        fitness_p(i_robot,:,:),fitness_pi(i_robot,:,:),...
        fitness_pg(i_robot,:)] =...
                fitness_subpopulation_restart(p_robots(:,:,1),i_robot,...
                    p_robots(i_robot,:,:),fitness_p(i_robot,:,:),...
                    pi_robots(i_robot,:,:),fitness_pi(i_robot,:,:),...
                    p_target,map_w,map_h);
      
    %% loop all the virtual individuals in a subpopulation
    for individual = 2:pop_sz
        %---generate the new generation   
        % calculate velocity
        v_robots_new = ...
            w .* v_robots(i_robot,:,individual) ...
            + c1*rand().*(pi_robots(i_robot,:,individual) ...
                          - p_robots(i_robot,:,individual))...
            + c2*rand().*(pg_robots(i_robot,:) ...
                          - p_robots(i_robot,:,individual));

        % modify the format of v_robots_new
        v_robots_new = one_step_direction(v_robots_new);

        % calculate position
        p_robots_new = p_robots(i_robot,:,individual) + v_robots_new;
        
        % restrict the position of each virtual robot to a fixed radius of
        % the real robots
        p_robots_new = ...
            within_scope( p_robots_new,p_robots(i_robot,:,1),radius );
        
        %---check if it is in the valid range
        if p_robots_new(1) <= map_w ...
                && p_robots_new(1) >= 1 ...
                && p_robots_new(2) <= map_h ...
                && p_robots_new(2) >= 1
            valid_range = true;
        else
            valid_range = false;
        end
        % END if p_robots_new <= map_w  
        
        %---only when valid, the following can be executed
        if valid_range
            %---fitness evaluation
            % make a copy of pr_robots and replace
            pr_robots_tmp = p_robots(:,:,1);
            pr_robots_tmp(i_robot,:) = p_robots_new;

            % evaluate the fitness
            fitness_p_new = fitness_encircle(pr_robots_tmp,i_robot,...
                                             p_target,map_w,map_h);

            %---generation update           
            if fitness_p_new <= fitness_p(i_robot,:,individual)
                p_robots(i_robot,:,individual) = p_robots_new;
                fitness_p(i_robot,:,individual) = fitness_p_new;
                v_robots(i_robot,:,individual) = v_robots_new;

                % update individual historical best
                if fitness_p_new <= fitness_pi(i_robot,:,individual)
                    pi_robots(i_robot,:,individual) = p_robots_new;
                    fitness_pi(i_robot,:,individual) = fitness_p_new;
                end
                % END if fitness_p_new <= fitness_pi(i_robot,:,individual) 

                % update the global best
                if fitness_p_new <= fitness_pg(i_robot,:)
                    pg_robots(i_robot,:) = p_robots_new;
                    fitness_pg(i_robot,:) = fitness_p_new;
                end
                % END if fitness_p_new <= fitness_pg            
            end
            % END if fitness_p_new < fitness_p(i_robot,:,individual)            
        end
        % END if valid_range
    end
    % END for individual = 2:pop_sz  
    
    %% maintain the diversity of a subpopulation
    % check unique virtual robots positions
    unique_virtual = length(unique(squeeze(...
                           p_robots(i_robot,:,2:end)).','rows','stable'));
    if unique_virtual <= UNIQUE_VIRTUAL          
        % redistribute the virtual robots
        p_robots(i_robot,:,:) = ...
            virtual_robots_redistribute(p_robots(i_robot,:,1),...
                                            pop_sz,radius,map_w,map_h);

        % re-evaluate the fitness values of these virutal robots
        [pi_robots(i_robot,:,:),pg_robots(i_robot,:,:),...
            fitness_p(i_robot,:,:),fitness_pi(i_robot,:,:),...
            fitness_pg(i_robot,:)] =...
                    fitness_subpopulation_restart(p_robots(:,:,1),...
                       i_robot,p_robots(i_robot,:,:),...
                       fitness_p(i_robot,:,:),pi_robots(i_robot,:,:),...
                       fitness_pi(i_robot,:,:),p_target,map_w,map_h); 
    end
    % END if unique_virtual < UNIQUE_VIRTUAL  
    
    %% loop the real robot in the subpopulation
    %---generate the new generation
    % calculate velocity
    v_robots_new = pg_robots(i_robot,:) - p_robots(i_robot,:,1);

    % modify the format of v_robots_new
    v_robots_new = one_step_direction(v_robots_new);

    % calculate position
    p_robots_new = p_robots(i_robot,:,1) + v_robots_new;
    
    %---check if it is in the valid range
    if p_robots_new(1) <= map_w ...
            && p_robots_new(1) >= 1 ...
            && p_robots_new(2) <= map_h ...
            && p_robots_new(2) >= 1
        valid_range = true;
    else
        valid_range = false;
    end
    % END if p_robots_new <= map_w    
    
    %---check whether exist collision
    % make a copy of pr_robots and replace
    pr_robots_tmp = p_robots(:,:,1);
    pr_robots_tmp(i_robot,:) = p_robots_new;
    
    pr_robots_tmp = pr_robots_tmp([1:(i_robot-1),(i_robot+1):end],:);
    p_obstacles = [pr_robots_tmp;p_target];
    collision = ...
        collision_moving(p_robots(i_robot,:,1),p_robots_new,p_obstacles);
    
    %---only when valid, the following can be executed
    if valid_range && ~collision
        %---fitness evaluation
        % make a copy of pr_robots and replace
        pr_robots_tmp = p_robots(:,:,1);
        pr_robots_tmp(i_robot,:) = p_robots_new;
    
        % evaluate the fitness
        fitness_p_new = fitness_encircle(pr_robots_tmp,i_robot,...
                                         p_target,map_w,map_h);    

        %---generation update
        if fitness_p_new <= fitness_p(i_robot,:,1)
            p_robots(i_robot,:,1) = p_robots_new;
            fitness_p(i_robot,:,1) = fitness_p_new;
            v_robots(i_robot,:,1) = v_robots_new;
            iters_still(i_robot) = 0;

            % update the global best
            if fitness_p_new <= fitness_pg(i_robot,:)       
                pg_robots(i_robot,:) = p_robots_new;
                fitness_pg(i_robot,:) = fitness_p_new;

                % the real robot becomes the global best in the 
                % subpopulation, redistribute the virtual robots around 
                % the limited neighborhood
                p_robots(i_robot,:,:) = ...
                    virtual_robots_redistribute(p_robots(i_robot,:,1),...
                                               pop_sz,radius,map_w,map_h);

                % re-evaluate the fitness value of these virutal robots
                [pi_robots(i_robot,:,:),pg_robots(i_robot,:,:),...
                    fitness_p(i_robot,:,:),fitness_pi(i_robot,:,:),...
                    fitness_pg(i_robot,:)] =...
                        fitness_subpopulation_restart(p_robots(:,:,1),...
                            i_robot,p_robots(i_robot,:,:),...
                            fitness_p(i_robot,:,:),...
                            pi_robots(i_robot,:,:),...
                            fitness_pi(i_robot,:,:),p_target,map_w,map_h);
            end
            % END if fitness_p_new <= fitness_pg
        elseif fitness_p(i_robot,:,1) > fitness_pg(i_robot,:)
            % if the real robot is not the global best but keeps still, 
            % then remember this.
            iters_still(i_robot) = iters_still(i_robot) + 1;  
        end
        % END if fitness_p_new <= fitness_p(i_robot,:,individual)

        % if the real robot is not the global best and keeps still for too
        % long then update its position to help it get out of the deadlock
        if fitness_p(i_robot,:,1) > fitness_pg(i_robot,:) ...
                && iters_still(i_robot) >= MAX_ITERS_STILL
            % update
            iters_still(i_robot) = 0;

            % update the position
            p_robots(i_robot,:,1) = random_move(p_robots(i_robot,:,1),...
                p_obstacles,map_w,map_h);

            %re-evaluate the fitness of all individuals
            [pi_robots,pg_robots,fitness_p,fitness_pi,fitness_pg] = ...
                fitness_update(p_target,p_robots,pi_robots,pg_robots,...
                               fitness_p,fitness_pi,fitness_pg,...
                               map_w,map_h);
        end
        % END if fitness_p(i_robot,:,1) > fitness_pg(i_robot,:) ...         
    end
    % END if valid_range && ~collision   
end
% END for i_robot = 1:n_robots

end