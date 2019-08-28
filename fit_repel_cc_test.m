%% clear
close all; clear all; clc;

%% configure
runtime_environment_configure;
simulation_repel_cc_configure;

%% loop
for iter_cc = 1:MAX_ITERS_CC   
    %% loop all the subpopulations and the (real & virtual) robots.
    [p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,v_robots]...
        = optimizer_pso_constrained(p_robots,fitness_p,pi_robots,...
        fitness_pi,pg_robots,fitness_pg,v_robots,w,c1,c2,map_w,map_h,radius);
    
    %% animation
    figure(f);
    clearpoints(ani_robots);
    clearpoints(ani_virtual_robots);
    
    addpoints(ani_robots,p_robots(:,1,1), p_robots(:,2,1));
    for i_robot = 1:n_robots
        addpoints(ani_virtual_robots,squeeze(p_robots(i_robot,1,2:pop_sz)),...
            squeeze(p_robots(i_robot,2,2:pop_sz)));
    end
    % END for i_robot = 1:n_robots
    
    title("iter\_cc = " + num2str(iter_cc));
    drawnow;

    %% record
    frames(iter_cc+1) = movie_record(f);        
end
% END for iter_cc = 1:MAX_ITERS_CC

%% save the movie data
movie_save(frames,movie_name);