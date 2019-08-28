%% convext hull
close all; clear all; clc;

xx = -1:.05:1;
yy = abs(sqrt(xx));
[x,y] = pol2cart(xx,yy);
k = convhull(x,y);
plot(x(k),y(k),'r-',x,y,'b*');

%% check points inside the polygon
rng default
IMAX = 1;
IMIN = -1;
xq = (IMAX-IMIN) * rand(250,1) + IMIN;
yq = (IMAX-IMIN) * rand(250,1) + IMIN;

[in,on] = inpolygon(xq,yq,x(k),y(k));

hold on; 
plot(xq(in&~on),yq(in&~on),'m+') % points inside
plot(xq(on),yq(on),'gp') % points on edge
plot(xq(~in),yq(~in),'yo') % points outside
hold off 

%% check a point inside the polygon
xq = (IMAX-IMIN) * rand(1,1) + IMIN;
yq = (IMAX-IMIN) * rand(1,1) + IMIN;

[in,on] = inpolygon(xq,yq,x(k),y(k))


%% create a polygon
xx = rand(10,2);
[k,v] = convhull(xx);
figure;
plot(xx(k,1),xx(k,2),'r-',xx(:,1),xx(:,2),'b*');

%% check points inside the polygon
rng default
IMAX = 1;
IMIN = 0;
xq = (IMAX-IMIN) * rand(250,1) + IMIN;
yq = (IMAX-IMIN) * rand(250,1) + IMIN;

[in,on] = inpolygon(xq,yq,xx(k,1),xx(k,2));

hold on; 
plot(xq(in&~on),yq(in&~on),'m+') % points inside
plot(xq(on),yq(on),'gp') % points on edge
plot(xq(~in),yq(~in),'yo') % points outside
hold off 

%% 
x = 0 : 0.01 : 10;
y1 = exp(-x);
y2 = exp(-2*x);
y3 = exp(-3*x);

y4 = 10*exp(-x);
y5 = 10*exp(-2*x);
y6 = 10*exp(-3*x);

y7 = 30*exp(-x);
y8 = 30*exp(-2*x);
y9 = 30*exp(-3*x);

y10 = 30*exp(-0.5*x);

figure; 
plot(x,y1,'-'); 
hold on; plot(x,y2,'-');
hold on; plot(x,y3,'-');

hold on; plot(x,y4,'-');
hold on; plot(x,y5,'-');
hold on; plot(x,y6,'-');

hold on; plot(x,y7,'-');
hold on; plot(x,y8,'-');
hold on; plot(x,y9,'-');

hold on; plot(x,y10,'-');

grid on; xticks(0:1:10);
legend('y1=exp(-x)', 'y2=exp(-2*x)','y3=exp(-3*x)',...
    'y4=10*exp(-*x)','y5=10*exp(-2*x)','y6=10*exp(-3*x)',...
    'y7=30*exp(-*x)','y8=30*exp(-2*x)','y9=30*exp(-3*x)',...
    'y10=30*exp(-0.5*x)');

%%
clear all; close all; clc;
x = 0 : 0.01 : 10;
y1 = exp(-x);
y2 = exp(-0.5*x);
y3 = exp(-2*x);
y4 = exp(-2*(x-2));

figure; 
plot(x,y1,'-'); 
hold on; plot(x,y2,'-');
hold on; plot(x,y3,'-');
hold on; plot(x,y4,'-');

grid on; xticks(min(x):1:max(x));
legend('y1 = exp(-x)','y2 = exp(-0.5*x)','y3 = exp(-2*x)',...
    'y4 = exp(-2*(x-2))');

%%
clear all; close all; clc;
x = -2 : 0.01 : 4;

y = exp(-2*(x-2));
figure; 
plot(x,y,'-'); 
grid on; xticks(min(x):1:max(x)); 
xlabel('D_{min}'); ylabel('y = e^{-2\cdot(x-2)}');

%%
clear all; close all; clc;
x = 0 : 0.01 : 5;

y = exp(-2*(x-2));
figure; 
plot(x,y,'-'); 
grid on; xticks(min(x):1:max(x)); 
xlabel('D_{min}'); ylabel('fit\_repel = e^{-2\cdot(D_{min} - 2)}');

%%
clear all; close all; clc;
D_MIN = 2;
NND_i = 0 : 0.01 : 5;
fit_repel = zeros(size(NND_i));

for idx = 1:length(NND_i)
    if NND_i(idx) <= D_MIN
        fit_repel(idx) = exp( -2*(NND_i(idx)-D_MIN) );
    else 
        fit_repel(idx) = 1;
    end
end

figure; 
plot(NND_i,fit_repel,'-'); 
grid on; xticks(min(NND_i):1:max(NND_i)); 
xlabel('NND'); ylabel('f_{repel} = e^{-2\cdot(NND - D_{min})}');

%%
L = linspace(0,2*pi,9);
xv = cos(L)';
yv = sin(L)';

figure; plot(xv, yv); axis equal; grid on;

%%
disp("a"); disp("b");

%%
disp("a");
disp("b");

%% 
close all; clear all; clc;
% rng(5);

n_robots = 10;
n_dim = 2;

points = rand([n_robots,n_dim]);

figure; scatter(points(:,1),points(:,2),'b'); grid on;
% xlim([0,10]); ylim([0,10]);

%% 
pmean = mean(points,1);

hold on; scatter(pmean(:,1),pmean(:,2),'r');

%%
pmedian = median(points);

hold on; scatter(pmedian(:,1),pmedian(:,2),'m');

%%
p_polar = norm(sum(points)) / size(points,1)

%%
[N,c] = hist3(points)
fit_even = std2(N)

figure; hist3(points);
xlabel("x"); ylabel("y");
title("fit\_even=" + num2str(fit_even));

%%
nbins = round(sqrt(n_robots));
[N,c] = hist3(points,'Nbins',[nbins,nbins])
fit_even = std2(N)

figure; hist3(points,'Nbins',[nbins,nbins]);
xlabel("x"); ylabel("y");
title("fit\_even=" + num2str(fit_even));

%%
xyminmax = minmax(points.')
xmin = xyminmax(1,1)
xmax = xyminmax(1,2)
ymin = xyminmax(2,1)
ymax = xyminmax(2,2)

%% 
edges = cell(2,1)
edges{1} = [xmin,pmean(1),Inf]
edges{2} = [ymin,pmean(2),Inf]

%
[N,c] = hist3(points,'Edges',edges) 
figure; hist3(points,'Edges',edges); 
xlabel("x"); ylabel("y");

%% 4 sections
ctrs = cell(2,1)
ctrs{1} = [mean([xmin,pmean(1)]), mean([pmean(1),xmax])];
ctrs{2} = [mean([ymin,pmean(2)]), mean([pmean(2),ymax])];

[N,c] = hist3(points,'Ctrs',ctrs) 
fit_even = std2(N)
figure; hist3(points,'Ctrs',ctrs); 
xlabel("x"); ylabel("y");
title("fit\_even=" + num2str(fit_even));

%% 
close all; clear all; clc;
rng(5);
n_robots = 10;
n_dim = 2;
points = round(30 .* rand([n_robots,n_dim]));
figure; 
scatter(points(:,1),points(:,2),'filled','s','MarkerEdgeColor','b','MarkerFaceColor','b');
grid on;

%% 
pmean = mean(points,1);
hold on; scatter(pmean(:,1),pmean(:,2),'r');

%%
xyminmax = minmax(points.');
xmin = xyminmax(1,1);
xmax = xyminmax(1,2);
ymin = xyminmax(2,1);
ymax = xyminmax(2,2);

%% edges
xedges = [xmin,pmean(1),xmax];
yedges = [ymin,pmean(2),ymax];

%% target 
p_target = [15, 15];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% legend
legend("real robots", "target");
xlabel("First dimension"); ylabel("Second dimension");

%% section line
hold on; line([15,15], [0,30],'Color','m','LineStyle','--');
hold on; line([0,30], [15,15],'Color','m','LineStyle','--');

%% edges
xedges = [xmin,p_target(1),xmax];
yedges = [ymin,p_target(2),ymax];

%%
h = histogram2(points(:,1),points(:,2),xedges,yedges);

figure; histogram2(points(:,1),points(:,2),xedges,yedges);

%%
fhist = figure('visible','on');
h = histogram2(points(:,1),points(:,2),xedges,yedges);
uniformity = std2(h.Values);
title("f_{uniformity} = "+num2str(uniformity));
xlabel("First dimension"); ylabel("Second dimension"); zlabel("Counts");

%%
status = close(fhist);

%%
[N,Xedges,Yedges,binX,binY] = histcounts2(points(:,1),points(:,2),xedges,yedges);


%%
diversity = @(q) q^(-1/(q-1)) - q^(-q/(q-1));
diversity(5)

%%
clc;
pr_robots = [5,7;9,7;7,7;11,7];
% [K,V] = convhull(pr_robots)
[K,V] = convhulln(pr_robots)

%% 
clc;
pr_robots = [5,7;9,7;7,7;11,7];
[in, on] = inpolygon(15, 15, pr_robots(:,1), pr_robots(:,2))

%% edges
xedges_1_min = min(xmin,p_target(1)-0.5);
xedges_1_mid = max(xmin,p_target(1)-0.5);
xedges_1_max = max(xmax,p_target(1)-0.5);
yedges_1_min = min(ymin,p_target(2)-0.5);
yedges_1_mid = max(ymin,p_target(2)-0.5);
yedges_1_max = max(ymax,p_target(2)-0.5);

xedges_2_min = min(xmin,p_target(1)+0.5);
xedges_2_mid = max(xmin,p_target(1)+0.5);
xedges_2_max = max(xmax,p_target(1)+0.5);
yedges_2_min = min(ymin,p_target(2)+0.5);
yedges_2_mid = max(ymin,p_target(2)+0.5);
yedges_2_max = max(ymax,p_target(2)+0.5);

xedges_1 = [xedges_1_min,xedges_1_mid,xedges_1_max];
yedges_1 = [yedges_1_min,yedges_1_mid,yedges_1_max];

xedges_2 = [xedges_2_min,xedges_2_mid,xedges_2_max];
yedges_2 = [yedges_2_min,yedges_2_mid,yedges_2_max];

%%
[N_1,Xedges_1,Yedges_1,binX_1,binY_1] = ...
    histcounts2(points(:,1),points(:,2),xedges_1,yedges_1);

[N_2,Xedges_2,Yedges_2,binX_2,binY_2] = ...
    histcounts2(points(:,1),points(:,2),xedges_2,yedges_2);

N = (N_1 + N_2) ./ 2;
disp("N = " + mat2str(N));

%% target 
p_target = [30, 15];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [0, 15];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [15, 0];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [15, 30];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [0, 0];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [30, 0];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [0, 30];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% target 
p_target = [30, 30];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

%% escape_line_choose test
close all; clear all; clc;
rng(5);
n_robots = 10;
n_dim = 2;
points = round(30 .* rand([n_robots,n_dim]));
map_w = max(points(:,1));
map_h = max(points(:,2));
figure; 
scatter(points(:,1),points(:,2),'filled','s','MarkerEdgeColor','b','MarkerFaceColor','b');
grid on;

p_target = [10, 10];
hold on; 
scatter(p_target(1),p_target(2),'filled','p','MarkerEdgeColor','r','MarkerFaceColor','r');

hold on; line([p_target(1),p_target(1)], [0,30],'Color','m','LineStyle','--');
hold on; line([0,30], [p_target(2),p_target(2)],'Color','m','LineStyle','--');



escape_dir = escape_line_choose(points,p_target,map_w,map_h);

%%
close all; clear all; clc;
escape_dir =  [1,  1];
vs_one_step = [1,0; 1,1; 0,1; -1,1; -1,0; -1,-1; 0,-1; 1,-1];
idx = find(ismember(vs_one_step,escape_dir,'rows') == true)

%% 
close all; clear all; clc;
escape_dir =  [1,1;  1,-1; -1,1];
vs_one_step = [1,0; 1,1; 0,1; -1,1; -1,0; -1,-1; 0,-1; 1,-1];
ismember(vs_one_step,escape_dir,'rows')
idx = find(ismember(vs_one_step,escape_dir,'rows') == true)

%% capture_status test
close all; clear all; clc;
map_w = 30;
map_h = 30;
p_target = [15,15];
pr_robots = [p_target(1)+1,p_target(2);...
             p_target(1),p_target(2)+1;...
             p_target(1)-1,p_target(2);...
             p_target(1),p_target(2)-1];
p_obstacle = [p_target(1)+1,p_target(2)];  

captured = capture_status(p_target,pr_robots,map_w,map_h)

%% swithc case
close all; clear all; clc;
prey_algorithms = ["still","linear_haynes","linear_smart"];
for prey = prey_algorithms
    switch prey
        case "still"
        case "linear_haynes"
            disp("linear_haynes");
        case "linear_smart"
            disp("linear_smart");
        otherwise
    end
end

%% save individual image
close all; clear; clc;

map_w = 30;
map_h = 30;

n_robots = 4;
n_dim = 2;
pop_sz = 20;

frame_name = 'test.png';

p_target = [15,15];
% pr_robots = [p_target(1)+1,p_target(2);...
%     p_target(1),p_target(2)+1;...
%     p_target(1)-1,p_target(2);...
%     p_target(1),p_target(2)-1];

[p_robots,fitness_p,pi_robots,fitness_pi,pg_robots,fitness_pg,v_robots,...
    radius] = ...
    init_cc_pso_encircle(n_robots,n_dim,pop_sz,p_target,map_w,map_h);

tic
frame_save(map_w,map_h,p_target,p_robots,frame_name);
toc

%%
close all; clear; clc;
ss = rand(4,2,3)
sss = reshape(ss,1,2,[])

%% 
close all; clear; clc;
% experiment specific parameters
docs_dir = "./data/D"+string(datestr(now,'yyyymmdd'))+"_pursuit/";

% make a new folder
if ~exist(docs_dir)
    system("mkdir -f "+docs_dir);
end
% END if ~exist(docs_dir)

%% 
close all; clear; clc;
n_robots = 4;
prey = "still";
seed = 1;
frame_name_prefix = "n_robots_"+n_robots+"_prey_"+prey+"_seed_"+seed
frame_name_initialization = frame_name_prefix + "_initialization.png"
frame_name_captured = frame_name_prefix + "_captured.png"
frame_name_converged = frame_name_prefix + "_converged.png"

%%
close all; clear; clc;
prey_algorithms = ["still","random","linear","linear_smart"];
for prey = prey_algorithms
    switch prey
        case {"still","random"}
            disp("non-linear");
        case {"linear","linear_smart"}
            disp("linear");
    end
end

%%
close all; clear; clc;
radius = 2;
num_elements = 8 * radius;
outer_boundary = zeros( num_elements ,2);

tic;
x = -radius:1:radius;
y = -radius:1:radius;

[xx,yy] = meshgrid(x,y);

outer_boundary(1:(2*radius+1), :) = [xx(:,1),yy(:,1)];
outer_boundary((2*radius+2):(4*radius+2), :) = [xx(:,end),yy(:,end)];
outer_boundary((4*radius+3):(6*radius+1), :) = ...
                                        [xx(1,2:end-1).',yy(1,2:end-1).'];
outer_boundary((6*radius+2):end, :) = ...
                                    [xx(end,2:end-1).',yy(end,2:end-1).'];
toc;

outer_boundary

%%
close all; clear; clc;
radius = 2;
num_elements = 8 * radius;
outer_boundary = zeros( num_elements ,2);
idx = 0;

tic;
%
x = -radius:1:radius;
y = -radius:1:radius;

%
for ix = [1,2*radius+1]
    for iy = 1:(2*radius+1)
        idx = idx + 1;
        outer_boundary(idx,1) = x(ix);
        outer_boundary(idx,2) = y(iy);
    end
    % END for iy = 1:(2*radius+1)
end
% END for ix = [1,2*radius+1]

%
for iy = [1,2*radius+1]
    for ix = 2:2*radius
        idx = idx + 1;
        outer_boundary(idx,1) = x(ix);
        outer_boundary(idx,2) = y(iy);
    end
    % END for ix = 2:2*radius
end
% END for iy = [1,2*radius+1]
toc;

disp(outer_boundary);

%% boxplot test
close all; clear all; clc;

% one example
load carsmall;
figure; boxplot(MPG,Origin);
title('Miles per Gallon by Vehicle Origin');
xlabel('Country of Origin');
ylabel('Miles per Gallon (MPG)');

% another example
rng default  % For reproducibility
x = randn(100,20);
figure;
subplot(2,1,1); boxplot(x);
hold on;
subplot(2,1,2); boxplot(x,'PlotStyle','compact');

%% boxplot_save test 
close all; clear all; clc;
% docs_dir = "./data/D20181226_D20181228_pursuit/";
% docs_dir = "./data/D201901091847_pursuit/";
% docs_dir = "./data/D201901101055_pursuit/";
docs_dir = "./data/D201901111124_pursuit/";
n_seeds = 100;
N_robots = [4,8,12,16,24]; 
prey_algorithms = ["still","random","linear","linear\_smart"];
boxplot_bar_save(docs_dir,n_seeds,N_robots,prey_algorithms);

%% display test
close all; clear all; clc;
n_seeds = 100;
COUNTS_NEWLINE = 50;

disp("Running: n_robots = ");
for seed = 1:n_seeds
    if seed == 1
        fprintf("         .");
    elseif mod(seed, COUNTS_NEWLINE) == 1
        fprintf("\n         .");
    else
        fprintf(".");  
    end
    % END if seed == 1
end
disp(newline);

%% re-calculate the standard deviation of the moves for 16 predators and 
close all; clear all; clc;

% linear_smart prey
filename = "./data/data_diagnose/n_roobts_16_linear_smart_moves";
fileID = fopen(filename,'r');
formatSpec_moves = "%5d";

% the first line of the document is the title
fgetl(fileID);

% get the data
moves = fscanf(fileID,formatSpec_moves);

% calculate the standard deviation of the moves: 50.4960
std(moves)

% close files
fclose(fileID);

%%
close all; clear all; clc;
for k = 1:10
    ;
end
k


%% learn to plot category data
close all; clear all; clc;
load patients
Location = categorical(Location);
SelfAssessedHealthStatus = categorical(SelfAssessedHealthStatus);
figure; histogram(SelfAssessedHealthStatus);
figure; hist([SelfAssessedHealthStatus,Location]);

%%
for k = 1:10
    if k == 2
        continue;
    end
    disp(k);
end
