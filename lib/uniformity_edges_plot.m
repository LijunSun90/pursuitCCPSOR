function uniformity_edges_plot(pr_robots,p_target)
%% uniformity_edges_plot - plot the historgram of the uniformity assessment
% 
% DESCRIPTION:
%       Plot the historgram of the uniformity assessment.
% 
% INPUT:
%       pr_robots       - positions of the real robots
%                         Matrix: n_robots x n_dim x 1
%       p_target        - position of the target
%                         Matrix: 1 x n_dim
% 
% 
% OUTPUT:
%       None
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       September 13, 2018

%% calculate
[uniformity,N,Xedges,Yedges] = uniformity_edges_calculate(pr_robots,p_target);

%% plot
figure; 
h = histogram2('XBinEdges',Xedges,'YBinEdges',Yedges,'BinCounts',N);
title("uniformity=" + num2str(uniformity));

end