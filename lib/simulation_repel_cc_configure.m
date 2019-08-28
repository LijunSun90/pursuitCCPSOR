%% simulation_repel_cc_configure - define the variables
% 
% REFERENCE:
%       None
% 
% 
% INPUT:
%       None
% 
% 
% OUTPUT:
%       None
% 
% 
% AUTHOR:
%       Lijun SUN

%% constant variables -- customer specified
% set random seed for repeatable experiments
seed = 5;

% map size
map_w = 30;
map_h = 15;

% robots number - the number of subpopulations
n_robots = 30;

% dimension of the space, such 2D and 3D
n_dim = 2;

%% set the name of the animated movie -- customer specified
movie_name = './data/test_repel_escape_cc_20180903.gif';

% real robots animation parameters
ani_robot_marker = 's';
ani_robot_marker_size = 5;
ani_robot_marker_color = 'b';

% virtual robots animation parameters
ani_virtual_robot_marker = '*';
ani_virtual_robot_marker_size = 3;
ani_virtual_robot_marker_color = 'g';


%% set cooperative coevolution (CC) parameters -- customer specified
% number of iterations of CC
MAX_ITERS_CC = 100; % 50
% subpopulation size
pop_sz = 20;

%% PSO specified parameters -- customer specified
% number of iterations
MAX_ITERS = 25;

c1 = 2;
c2 = 2;
w = 1;

% solution space of position
p_min = zeros(1, n_dim);
p_max = [map_w, map_h];

%% set random seed
rng(seed);

%% generate target initial positions
p_target = init_target_pos2d(map_w, map_h);

%% generate robots initial positions
[p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,v_robots,...
    radius] = ...
    init_cc_pso_constrained_robots(n_robots,n_dim,pop_sz,p_max,p_min);
 
%% generate the map
f = map_create(map_w, map_h);

%% define animation varaibles
ani_robots = animation_create(ani_robot_marker,ani_robot_marker_size,...
    ani_robot_marker_color);
ani_virtual_robots = animation_create(ani_virtual_robot_marker,...
    ani_virtual_robot_marker_size,ani_virtual_robot_marker_color);

%% plot the initial state of the animation
addpoints(ani_robots,p_robots(:,1,1), p_robots(:,2,1));
for i_robot = 1:n_robots
    addpoints(ani_virtual_robots,squeeze(p_robots(i_robot,1,2:pop_sz)),...
        squeeze(p_robots(i_robot,2,2:pop_sz)));
end
% END for i_robot = 1:n_robots

title("iter\_cc = 0");
drawnow;

% record
frames(1) = movie_record(f);

%% display
disp("Simulation environment configure is DONE!")