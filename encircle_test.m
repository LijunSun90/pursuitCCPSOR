%encircle_test - 
% ------------------------------------------------------------------------
% AUTHOR:
%       Lijun SUN
% ------------------------------------------------------------------------

%% running time calculation: start
starttime = tic;

%% calculate the straight line escape direction for the target prey robot
switch prey
    case {"linear","linear\_smart"}
        escape_dirs = escape_line_choose(p_robots(:,:,1),p_target,...
                                         map_w,map_h);
    otherwise
        % do nothing
end

%% loop
for iter_cc = 1:MAX_ITERS_CC    
    %% dynamic  
    % jump over the first iteration for the dynamic prey
    if mod(iter_cc, ITERS_TARGET_NOT_UPDATE) && iter_cc > 1
        switch prey
            case "random"
                p_target = p_target_random(p_target,...
                    p_robots(:,:,1),map_w,map_h);
            case "linear"
                [p_target,escape_dirs] = p_target_linear(p_target,...
                    p_robots(:,:,1),map_w,map_h,escape_dirs);
            case "linear\_smart"
                [p_target,escape_dirs] = p_target_linear_smart(...
                    p_target,p_robots(:,:,1),map_w,map_h,escape_dirs);
            otherwise
                % do nothing
        end
        % END switch prey
    end
    % END if ~mod(iter_cc, ITERS_UPDATE) 
    
    %% preserve variable
    pr_robots_last = p_robots(:,:,1);
    
    %% loop all the subpopulations, including the (real & virtual) robots.
    [p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,...
        v_robots,iters_still]...
        = optimizer_cc_pso_encircle(p_robots,fitness_p,pi_robots,...
        fitness_pi,pg_robots,fitness_pg,v_robots,w,c1,c2,map_w,map_h,...
        radius,p_target,iters_still,captured);

    %% animation
    if animation_on
        encircle_animation;
        fitness_curves_plot;  
    end
    % END if animation_on
    
    %% capture status examination
    captured = capture_status(p_target,p_robots(:,:,1),map_w,map_h);
    
    %% convergence status examination
    [converged, iters_cc_converging] = converge_status(pr_robots_last,...
                                    p_robots(:,:,1),iters_cc_converging);
    
    %% experiment status examination and actions
    if captured && ~captured_recorded
        iters_cc_captured = iter_cc;
        captured_recorded = true;
        
        % running time calculation: end
        runtime = toc(starttime);
        
        % save the captured frame if the animation is turned off
        if ~animation_on
            frame_save(map_w,map_h,p_target,p_robots,frame_name_captured);
        end
        % END if ~animation_on
    end
    % END if captured
    
    % 
    if converged
        if captured
            % if the target has been captured, while the predator swarm 
            % robots has also converged, then the game is over.
            
            % preserve the data
            iters_cc_converged = iter_cc - iters_cc_converging;   

            % save the converged frame if the animation is turned off
            if ~animation_on
                frame_save(map_w,map_h,p_target,p_robots,...
                           frame_name_converged);
            end
            % END if ~animation_on
            
            % the game is over, exit
            break;
        else
            % if the target has NOT been captured, but the predator swarm 
            % has converged which is an exception, then add a random noise 
            % to the whole predator swarm robots 
            p_robots(:,:,1) = swarm_random_move(p_robots(:,:,1),...
                              p_target,map_w,map_h);

            %re-evaluate the fitness of all individuals
            [pi_robots,pg_robots,fitness_p,fitness_pi,fitness_pg] = ...
                fitness_update(p_target,p_robots,pi_robots,pg_robots,...
                              fitness_p,fitness_pi,fitness_pg,map_w,map_h);

            % the converged status is fake, so update the memory
            converged = false;
            iters_cc_converging = -1;            
        end
        % END if captured
    end
    % END if converged
end
% END for iter_cc = 1:MAX_ITERS_CC

%% save the data
% save the movie data
if animation_on
    movie_save(frames,movie_name);  
end
% END if animation_on

%% close
% if animation_on
%     close('all');  
% end
% END if animation_on
