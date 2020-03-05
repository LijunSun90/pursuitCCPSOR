function boxplot_bar_save(docs_dir,n_seeds,N_predators,prey_algorithms)
%boxplot_bar_save - save boxplot and bar graph results
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Parse the dedicated documents "experiments_data.txt" and 
%       "experiments_statistics.txt", box plot these data, create their bar
%       graphs, and save them to the disk.
% 
% INPUT:
%       docs_dir        - the absolute or relative directory path to read 
%                         and save relevant files
%                         String
%       n_seeds         - number of different random number generator
%                         seeds, i.e., number of test cases for a specific
%                         number of predators and a specific type of prey
%                         Scalar
%       N_predators     - Set of the number of predators used to capture
%                         the prey. For example, for [4,8,12,16,24].
%                         Matrix: 1 x n_predators 
%                                    (n_predators = length(N_predators))
%       prey_algorithms - Set of the prey types. For example,
%                         ["still","random","linear","linear_smart"].
%                         Matrix: 1 x n_preys 
%                                     (n_preys = length(prey_algorithms))
% 
% OUTPUT:
%       None. But a boxplot.png and a boxplot_compact.png are saved to the
%       disk.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Jan 2, 2019
%-------------------------------------------------------------------------

%% define variables
% pre-processing the input parameters
n_predators = length(N_predators);
n_preys = length(prey_algorithms);

% filename
filename_data = docs_dir + "experiments_data.txt";
filename_statistics = docs_dir + "experiments_statistics.txt";

% data file format
formatSpec_data_title = '%8s %13s %4s %8s %5s %9s %15s %10s';
formatSpec_moves = '%*d %*s %*d %*d %5d %*d %*d %*f';
size_moves = [n_seeds, n_predators*n_preys];

% statistics file format
formatSpec_statistics_title = ...
    ['%-8s %-13s %-5s',...
    ' %-8s %-9s %-9s %-9s %-9s',...
    ' %-9s %-19s %-19s',...
    ' %-19s %-19s',...
    ' %-15s %-15s %-14s %-11s\n'];
formatSpec_groups = '%8s %13s %*[^\n]';
delimeter_groups = ' ';
num_groups = n_predators*n_preys;

formatSpec_statistics = ...
    ['%*d %*s %*d',...
    ' %*d %*d %*d %9f %*f',...
    ' %*d %*d %*d',...
    ' %*f %*f',...
    ' %*f %*f %*f %*f'];

%% parse the experiment data file
fileID_data = fopen(filename_data,'r');

% the first line of the document is the title
[~,~] = textscan(fileID_data,formatSpec_data_title,1);

% get the number of moves for a specific number of predators and a specific
% prey
% moves = fscanf(fileID_data,formatSpec_moves,size_moves);
moves = textscan(fileID_data,formatSpec_moves);
moves = reshape(moves{1,1},size_moves);

% close files
fclose(fileID_data);
              
%% parse the experiment statistics data file and get the group information
fileID_statistics = fopen(filename_statistics,'r');

% the first line of the document is the title
[~,position_statistics] = ...
    textscan(fileID_statistics,formatSpec_statistics_title,1);

% get the group information [n_robots, prey]
groups = textscan(fileID_statistics,formatSpec_groups,num_groups,...
                  'Delimiter',delimeter_groups,'MultipleDelimsAsOne',1);
disp(groups);
              
% get the statistics data
fseek(fileID_statistics,position_statistics,'bof');
avg_moves = fscanf(fileID_statistics,formatSpec_statistics,[num_groups,1]);

% get the statistics data
fseek(fileID_statistics,position_statistics,'bof');
formatSpec_statistics = ...
    ['%*d %*s %*d',...
    ' %*d %*d %*d %9f %9f',...
    ' %*d %*d %*d',...
    ' %*f %*f',...
    ' %*f %*f %*f %*f'];
statistics = textscan(fileID_statistics,formatSpec_statistics,...
    num_groups,'Delimiter',delimeter_groups,'MultipleDelimsAsOne',1);

% group the bar graph by the number of predators
avg_moves_group_predator = reshape(avg_moves,n_preys,n_predators).';

% group the bar graph by the type of preys
avg_moves_group_prey = reshape(avg_moves,n_preys,n_predators);

% group the bar graph by the type of preys
avg_moves_group_prey_err = statistics{1};
std_moves_group_prey_err = statistics{2};

% resize the data
avg_moves_group_prey_err = reshape(avg_moves_group_prey_err,...
                                   n_preys,n_predators);
std_moves_group_prey_err = reshape(std_moves_group_prey_err,...
                                   n_preys,n_predators);

% close files
fclose(fileID_statistics);
              
%% boxplot
boxplot_name = char(docs_dir + "boxplot.png");
f_boxplot = figure('Name','boxplot','Visible','on'); 
% boxplot(moves,groups,'Notch','on');
boxplot(moves,'Notch','on');

xlabel("Number of predators together with a prey type");
ylabel("Moves to capture the prey");

% save boxplot
num_groups = size(groups{1});
num_groups = num_groups(1);
xticklabel = cell(num_groups, 1);
for idx = 1:1:num_groups
    xticklabel{idx} = ['$$\begin{array}{c}',groups{1}{idx},'\\',...
        groups{2}{idx},'\end{array}$$'];
end

set(f_boxplot.CurrentAxes,'XTickLabel',xticklabel,...
    'XTickLabelRotation',90,'TickLabelInterpreter','latex',...
    'Fontsize',26,'LineWidth',1);
set(f_boxplot,'WindowState','max','Color','white');
frame_boxplot = getframe(f_boxplot);
imwrite(frame_boxplot.cdata, boxplot_name);

% close figure
close(f_boxplot);

%% compact boxplot
boxplot_compact_name = char(docs_dir + "boxplot_compact.png");
f_boxplot_compact = figure('Name','boxplot_compact','Visible','on'); 
boxplot(moves,groups,'PlotStyle','compact','Notch','on');
xlabel("Number of predators together with a prey type");
ylabel("Moves to capture the prey");

% save compact boxplot
set(f_boxplot_compact,'WindowState','max','Color','white');
% set(f_boxplot_compact,'Color','white');
frame_boxplot_compact = getframe(f_boxplot_compact);
imwrite(frame_boxplot_compact.cdata, boxplot_compact_name);

% close figure
close(f_boxplot_compact);

%% bar graph grouped by predators
% plot
bar_group_predator_name = char(docs_dir + "bar_group_predator.png");
f_bar_group_predator = figure('Name','bar_group_predator','Visible','on');
if n_predators == 1
    bar(avg_moves_group_predator);
    set(f_bar_group_predator.CurrentAxes,....
        'XTickLabel',prey_algorithms);   
    xlabel('Type of the prey'); 
else
    c_group_predator = categorical(N_predators);
    bar(c_group_predator,avg_moves_group_predator);
    legend(prey_algorithms);
    xlabel('Number of predators');  
end
% END if n_predators == 1
ylabel('Average number of moves to capture the prey');  

% save
set(f_bar_group_predator,'Color','white');
frame_bar_group_predator = getframe(f_bar_group_predator);
imwrite(frame_bar_group_predator.cdata, bar_group_predator_name);

% close
close(f_bar_group_predator);

%% bar graph grouped by preys
bar_group_prey_name = char(docs_dir + "bar_group_prey.png");
f_bar_group_prey = figure('Name','bar_group_prey','Visible','on');
c_group_prey = categorical(prey_algorithms,prey_algorithms,'Ordinal',true);
bar(c_group_prey,avg_moves_group_prey);
legend(string(N_predators) + " predators", 'Location', 'best');
xlabel('Type of the prey');
ylabel('Average number of moves to capture the prey');

% save
set(gca,'FontSize',14);
set(f_bar_group_prey,'Color','white');
frame_bar_group_prey = getframe(f_bar_group_prey);
imwrite(frame_bar_group_prey.cdata, bar_group_prey_name);

% close
close(f_bar_group_prey);

%% bar graph grouped by preys, with standard deviation 
% bar plot
bar_err_group_prey_name = char(docs_dir + "bar_err_group_prey.png");
f_bar_err_group_prey = figure('Name','bar_err_group_prey','Visible','on');
h_bar_err_group_prey = bar(avg_moves_group_prey_err);

% error bars plot
hold on;
[~,n_bars] = size(avg_moves_group_prey_err);

% set the position of each error bar in the centre of the main bar
for i_bar = 1:n_bars
    % calculate center of each bar
    x = bsxfun(@plus, h_bar_err_group_prey(i_bar).XData.',...
        h_bar_err_group_prey(i_bar).XOffset);
    % plot
    errorbar(x,avg_moves_group_prey_err(:,i_bar),...
             std_moves_group_prey_err(:,i_bar),'.','Color','k');
end
% END for i_bar = 1:n_bars

% re-set the xlabels
set(f_bar_err_group_prey.CurrentAxes,....
    'XTickLabel',prey_algorithms);

% save
set(f_bar_err_group_prey,'Color','white');
frame_bar_err_group_prey = getframe(f_bar_err_group_prey);
imwrite(frame_bar_err_group_prey.cdata, bar_err_group_prey_name);

% close the figure
close(f_bar_err_group_prey);

end