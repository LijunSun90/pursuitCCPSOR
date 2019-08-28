function [uniformity,N,Xedges,Yedges] = ...
    uniformity_edges_calculate(pr_robots,p_target,map_w,map_h)
%uniformity_edges_calculate - calculate the uniformity
%-------------------------------------------------------------------------
% 
% DESCRIPTION:
%       Calculate the uniformity of the group around the position p_target.
% 
%       The following pesudo-uniformity can be avoided:
%       (* real robots; # target)
% 
%       -*-*-
%       --#--
%       --*--
%       --*--
% 
%       lower left edges classification:   N_1 = [1,1;0,2];
%       higher right edges classification: N_2 = [1,1;2,0];
%       lower right edges classification:  N_3 = [1,1;2,0];
%       higher left edges classification:  N_4 = [1,1;0,2];
% 
%       N = (N_1 + N_2 + N_3 + N_4) ./ 4 = [1,1;1,1]; -- uniformity? No!
%       
%       This situation will be checked out and recalculate the uniformity 
%       using the following function:
% 
%       uniformity_symmetry_calculate(pr_robots,p_target,map_w,map_h)
% 
% 
% INPUT:
%       pr_robots       - positions of the real robots
%                         Matrix: n_robots x n_dim x 1
%       p_target        - position of the target
%                         Matrix: 1 x n_dim
%       map_w           - width of the map
%                         Scalar
%       map_h           - height of the map
%                         Scalar
% 
% 
% OUTPUT:
%       uniformity      - uniformity of the group
%                         Scalar
%       N               - Bin counts, specified as a matrix.
%       Xedges          - Bin edges in x-dimension, specified as a vector. 
%       Yedges          - Bin edges in y-dimension, specified as a vector. 
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 13, 2018
%-------------------------------------------------------------------------

%% ranges of group position coordinates
xyminmax = minmax(pr_robots.');
xmin = xyminmax(1,1);
xmax = xyminmax(1,2);
ymin = xyminmax(2,1);
ymax = xyminmax(2,2);

%% edges
% lower left
xedges_1_min = min(xmin,p_target(1)-0.5);
xedges_1_mid = max(xmin,p_target(1)-0.5);
xedges_1_max = max(xmax,p_target(1)-0.5);
yedges_1_min = min(ymin,p_target(2)-0.5);
yedges_1_mid = max(ymin,p_target(2)-0.5);
yedges_1_max = max(ymax,p_target(2)-0.5);

% higher right
xedges_2_min = min(xmin,p_target(1)+0.5);
xedges_2_mid = max(xmin,p_target(1)+0.5);
xedges_2_max = max(xmax,p_target(1)+0.5);
yedges_2_min = min(ymin,p_target(2)+0.5);
yedges_2_mid = max(ymin,p_target(2)+0.5);
yedges_2_max = max(ymax,p_target(2)+0.5);

% lower right
xedges_3_min = min(xmin,p_target(1)+0.5);
xedges_3_mid = max(xmin,p_target(1)+0.5);
xedges_3_max = max(xmax,p_target(1)+0.5);
yedges_3_min = min(ymin,p_target(2)-0.5);
yedges_3_mid = max(ymin,p_target(2)-0.5);
yedges_3_max = max(ymax,p_target(2)-0.5);

% higher left
xedges_4_min = min(xmin,p_target(1)-0.5);
xedges_4_mid = max(xmin,p_target(1)-0.5);
xedges_4_max = max(xmax,p_target(1)-0.5);
yedges_4_min = min(ymin,p_target(2)+0.5);
yedges_4_mid = max(ymin,p_target(2)+0.5);
yedges_4_max = max(ymax,p_target(2)+0.5);

% lower left
xedges_1 = [xedges_1_min,xedges_1_mid,xedges_1_max];
yedges_1 = [yedges_1_min,yedges_1_mid,yedges_1_max];

% higher right
xedges_2 = [xedges_2_min,xedges_2_mid,xedges_2_max];
yedges_2 = [yedges_2_min,yedges_2_mid,yedges_2_max];

% lower right
xedges_3 = [xedges_3_min,xedges_3_mid,xedges_3_max];
yedges_3 = [yedges_3_min,yedges_3_mid,yedges_3_max];

% higher left
xedges_4 = [xedges_4_min,xedges_4_mid,xedges_4_max];
yedges_4 = [yedges_4_min,yedges_4_mid,yedges_4_max];

%% uniformity
% lower left
[N_1,Xedges_1,Yedges_1,binX_1,binY_1] = ...
    histcounts2(pr_robots(:,1),pr_robots(:,2),xedges_1,yedges_1);

% higher right
[N_2,Xedges_2,Yedges_2,binX_2,binY_2] = ...
    histcounts2(pr_robots(:,1),pr_robots(:,2),xedges_2,yedges_2);

% lower right
[N_3,Xedges_3,Yedges_3,binX_3,binY_3] = ...
    histcounts2(pr_robots(:,1),pr_robots(:,2),xedges_3,yedges_3);

% higher left
[N_4,Xedges_4,Yedges_4,binX_4,binY_4] = ...
    histcounts2(pr_robots(:,1),pr_robots(:,2),xedges_4,yedges_4);

Xedges = (Xedges_1 + Xedges_2 + Xedges_3 + Xedges_4) ./ 4;
Yedges = (Yedges_1 + Yedges_2 + Yedges_3 + Yedges_4) ./ 4;

N = (N_1 + N_2 + N_3 + N_4) ./ 4;
% N = (N_1 + N_2) ./ 2;
uniformity = std2(N);

%% check whether it is really uniform
if uniformity == 0
    N_joint = zeros(2,2,4);
    N_joint(:,:,1) = N_1;
    N_joint(:,:,2) = N_2;
    N_joint(:,:,3) = N_3;
    N_joint(:,:,4) = N_4;
    N_joint = N_joint - N_joint(1,1,:);
    if ~isequal(N_joint, zeros(2,2,4))
        uniformity = ...
            uniformity_symmetry_calculate(pr_robots,p_target,map_w,map_h);
    end
    % END if isequal(N_joint, zeros(4,4,4))
end
% END if uniformity == 0

%% debug
% disp("N = " + mat2str(N));

end