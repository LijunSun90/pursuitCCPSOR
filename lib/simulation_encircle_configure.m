%simulation_encircle_configure - define the variables
%-------------------------------------------------------------------------
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 3, 2018
%-------------------------------------------------------------------------

%% constant variables -- customer specified
% map size：map_w = 30; map_h = 30;
map_w = 30; 
map_h = 30; 

% target number
% n_target = 1;

% dimension of the space, such 2D and 3D
n_dim = 2;

%% set the dynamic environment parameters -- customer specified
% every number of iterations not to update the position p_target
ITERS_TARGET_NOT_UPDATE = 10; % 30,5

%% set cooperative coevolution (CC) parameters -- customer specified
% number of iterations of CC
MAX_ITERS_CC = 1000; 

% subpopulation size: pop_sz = 20;
pop_sz = 20;

% capture status: boolean
captured = false;

% number of iterations of CC to capture the target
iters_cc_captured = 0;

% flag to record whether the "true" captured status has been recorded
captured_recorded = false;

% number of iterations of CC to converge
iters_cc_converged = 0;

% number of iterations of CC for the real robots to keep converging (still)
iters_cc_converging = 0;

%% PSO specified parameters -- customer specified
c1 = 2;
c2 = 2;
w = 1;

% number of iterations of the real robot keeping still
iters_still = zeros(n_robots,1);

%% define the name of the frames to be saved
frame_name_prefix = docs_dir + "n_robots_" + n_robots + "_prey_" + prey ...
                             + "_seed_" + seed;
frame_name_initialization =char(frame_name_prefix + "_initialization.png");
frame_name_captured = char(frame_name_prefix + "_captured.png");
frame_name_converged = char(frame_name_prefix + "_converged.png");

% if the animation is turned on, define the movie name
if animation_on
    movie_name = char(docs_dir + "n_robots_" + n_robots  ...
                      + "_prey_" + prey + "_seed_" + seed + ".gif");
end
% END if animation_on

%% generate target initial positions
p_target = init_target_pos2d(map_w, map_h);

%% generate robots initial positions
[p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,v_robots,...
    radius] = ...
    init_cc_pso_encircle(n_robots,n_dim,pop_sz,p_target,map_w,map_h);

%% save the initialization frame if the animation is turned off
if ~animation_on
    frame_save(map_w,map_h,p_target,p_robots,frame_name_initialization);
end
% END if ~animation_on

%% errors and warnings configuration
% treat warnings as errors and thus catch them with a try ... catch 
% statement
warning('error', 'MATLAB:inpolygon:ModelingWorldLower');

%% set animation parameters -- customer specified
if animation_on
    % target animation parameters
    ani_target_marker = 'p';
    ani_target_marker_size = 8;
    ani_target_marker_color = 'r';

    % real robots animation parameters
    ani_robot_marker = 's';
    ani_robot_marker_size = 5;
    ani_robot_marker_color = 'b';

    % virtual robots animation parameters
    ani_virtual_robot_marker = '*';
    ani_virtual_robot_marker_size = 3;
    ani_virtual_robot_marker_color = 'g';

    %% generate the map
    f = map_create(map_w, map_h,false,true);

    %% define animation varaibles
    % real robots
    ani_robots = animation_create(ani_robot_marker,...
        ani_robot_marker_size,ani_robot_marker_color);

    % virtual robots
    ani_virtual_robots = animation_create(ani_virtual_robot_marker,...
        ani_virtual_robot_marker_size,ani_virtual_robot_marker_color);

    % target
    ani_target = animation_create(ani_target_marker,...
        ani_target_marker_size,ani_target_marker_color);

    %% plot the initial state of the animation
    % real robots
    addpoints(ani_robots,p_robots(:,1,1), p_robots(:,2,1));

    % virtual robots
    for i_robot = 1:n_robots
        addpoints(ani_virtual_robots,...
            squeeze(p_robots(i_robot,1,2:pop_sz)),...
            squeeze(p_robots(i_robot,2,2:pop_sz)));
    end
    % END for i_robot = 1:n_robots

    % target
    addpoints(ani_target, p_target(:,1), p_target(:,2));

    % title
%     title("iter\_cc = 0");
    ht = text(map_w-2,map_h-2,"0");
    drawnow;

    % record
    frames(1) = movie_record(f);

    %% plot the fitness evaluation over generations
    % real robots
    f_curve = figure('Name', 'Curve');
    ax_fitness_pr = subplot(2, 3, 1); grid on; title('f');
    ax_fit_closure = subplot(2, 3, 2); grid on; title('f_{closure}');
    ax_fit_expanse = subplot(2, 3, 3); grid on; title('f_{expanse}');
    ax_fit_uniformity = subplot(2, 3, 5); grid on; title('f_{uniformity}');
    ax_NND = subplot(2, 3, 6); grid on; title('NND');
end
% END if animation_on
