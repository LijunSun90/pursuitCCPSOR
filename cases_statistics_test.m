%cases_statistics_test -
%-------------------------------------------------------------------------
% 
% DESCRIPTION:
%       Test the algorithm over numbers of different experiments.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Nov 22, 2018
%-------------------------------------------------------------------------

%% clear
close all; clear; clc;

%% configure runtime environment
runtime_environment_configure;

%% define variables -- customer specified
% Show the animation of the game or not. 
% When to collect the statistical results, it is faster to turn it off.
% Otherwise, an animation will be displaed on the screen in real time.
% true; false;
animation_on = true;

% 100
n_seeds = 1;
% [4,8,12,16,24]
N_robots = [4]; 
% ["still","random","linear","linear\_smart"]
prey_algorithms = ["linear\_smart"];

% number to display a newline symbol
COUNTS_NEWLINE = 50;

% experiment specific parameters
docs_dir = "./data/D"+datestr(now,'yyyymmddHHMM')+"_pursuit/";

% make a new folder
if ~exist(docs_dir,'dir')
    system("mkdir "+docs_dir);
end
% END if ~exist(docs_dir)

% filenames definition
filename_data = docs_dir + "experiments_data.txt";
filename_statistics = docs_dir + "experiments_statistics.txt";

% open files
fileID_data = fopen(filename_data,'w+');
fileID_statistics = fopen(filename_statistics,'w+');

% format specification
formatSpec_data_title = '%-8s %-13s %-4s %-8s %-5s %-9s %-15s %-10s\n';
formatSpec_data = '%-8d %-13s %-4d %-8d %-5d %-9d %-15d %-10.4f\n';
formatSpec_statistics_title = ...
    ['%-8s %-13s %-5s',...
    ' %-8s %-9s %-9s %-9s %-9s',...
    ' %-9s %-19s %-19s',...
    ' %-19s %-19s',...
    ' %-15s %-15s %-14s %-11s\n'];
formatSpec_statistics = ...
    ['%-8d %-13s %-5d',...
    ' %-8d %-9d %-9d %-9.3f %-9.3f',...
    ' %-9d %-19d %-19d',...
    ' %-19.3f %-19.3f',...
    ' %-15.4f %-15.4f %-14.4f %-11.4f\n'];

% write titles to the files
fprintf(fileID_data,formatSpec_data_title,...
    'n_robots','prey','seed','captured','moves',...
    'converged','moves_converged','runtime(s)');
fprintf(fileID_statistics,formatSpec_statistics_title,...
    'n_robots','prey','seeds',...
    'captures','moves_min','moves_max','avg_moves','std_moves',...
    'converges','moves_converged_min','moves_converged_max',...
    'avg_moves_converged','std_moves_converged',...
    'rumtimes_min(s)','rumtimes_max(s)','avg_rumtime(s)','std_runtime');

%% loop
for n_robots = N_robots
    for prey = prey_algorithms
        % define variables
        captures = 0;
        moves = zeros(n_seeds,1);
        avg_moves = 0;

        converges = 0;
        moves_converged = zeros(n_seeds,1);
        avg_moves_converged = 0;
        
        runtimes = zeros(n_seeds,1);
        avg_runtimes = 0;
        
        % trace the experiment progress
        experiment_trace = "Running: n_robots = " + n_robots + ...
                                        ", prey = " + prey + ...
                                        ", seed = 1:" + n_seeds;
        disp(experiment_trace);
        
        % loop
        for seed = 1:n_seeds
            % set random seed
            rng(seed);

            % configure the experiment
            simulation_encircle_configure;

            % run the experiment
            encircle_test;

            % calculate experiment data
            if captured
                captures = captures + 1;
                moves(seed) = iters_cc_captured;
                avg_moves = avg_moves + moves(seed);
            else
                moves(seed) = NaN;
            end
            % END if captured
            
            if converged
                converges = converges + 1;
                % moves                
                moves_converged(seed) = iters_cc_converged;
                avg_moves_converged = avg_moves_converged + ...
                    moves_converged(seed);
                % runtime
                runtimes(seed) = runtime;
                avg_runtimes = avg_runtimes + runtimes(seed);                
            else
                % moves
                moves_converged(seed) = NaN;
                % runtime
                runtimes(seed) = NaN;                
            end
            % END if converged
            
            % write experiment data to the files
            fprintf(fileID_data,formatSpec_data,n_robots,prey,seed,...
                captured,moves(seed),converged,moves_converged(seed),...
                runtimes(seed));
            
            % trace the experiment progress
            if seed == 1
                fprintf("         .");
            elseif mod(seed, COUNTS_NEWLINE) == 1
                fprintf("\n         .");
            else
                fprintf(".");  
            end
            % END if seed == 1
        end
        % END for seed = 1:n_seeds
        
        % trace the experiment progress
        disp(newline);
        
        % calculate experiment data
        moves_min = min(moves);
        moves_max = max(moves);
        avg_moves = avg_moves / captures;
        std_moves = std(moves(~isnan(moves)));
        
        runtimes_min = min(runtimes);
        runtimes_max = max(runtimes);
        avg_runtimes = avg_runtimes / captures;
        std_runtimes = std(runtimes(~isnan(runtimes)));
        
        moves_converged_min = min(moves_converged);
        moves_converged_max = max(moves_converged);
        avg_moves_converged = avg_moves_converged / converges;
        std_moves_converged = std(moves_converged(moves_converged ~= 0));        
        
        % write experiment data to the files
        fprintf(fileID_statistics,formatSpec_statistics,...
            n_robots,prey,n_seeds,...
            captures,moves_min,moves_max,avg_moves,std_moves,...
            converges,moves_converged_min,moves_converged_max,...
            avg_moves_converged,std_moves_converged,....
            runtimes_min,runtimes_max,avg_runtimes,std_runtimes);        
    end
    % END for prey = prey_algorithms
end
% END for n_robots = N_robots

%% close files
fclose(fileID_data);
fclose(fileID_statistics);

%% save boxplot result
n_preys = length(prey_algorithms);
boxplot_bar_save(docs_dir,n_seeds,N_robots,prey_algorithms);

%% display
disp("Completed!");
