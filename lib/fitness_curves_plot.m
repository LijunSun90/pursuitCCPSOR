%% fitness_curves_plot -
% 
% DESCRIPTION:
%       Draw the fitness curves of the experiment.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 6, 2018
  
%% plot the fitness over generations
[fitness_pr,fit_closure,fit_expanse,fit_uniformity,NND] = ...
    fitness_encircle_real(p_robots(:,:,1),p_target,map_w,map_h);
hold(ax_fitness_pr,'on'); plot(ax_fitness_pr, iter_cc, fitness_pr,'*');
hold(ax_fit_closure,'on'); plot(ax_fit_closure, iter_cc, fit_closure,'*');
hold(ax_fit_expanse,'on'); plot(ax_fit_expanse, iter_cc, fit_expanse,'*');
hold(ax_fit_uniformity,'on'); 
plot(ax_fit_uniformity, iter_cc, fit_uniformity,'*');
hold(ax_NND,'on'); plot(ax_NND, iter_cc, NND,'*');
