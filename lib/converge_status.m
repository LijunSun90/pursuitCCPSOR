function [converged, iters_cc_converging] = ...
    converge_status(pr_robots_last,pr_robots_current,iters_cc_converging)
%% converge_status -
% 
% DESCRIPTION:
%       Determine whether the predator swarm robots have converged.
% 
% INPUT:
%       pr_robots_last      - positions of the real robots in the last
%                             iteration
%                             Matrix: n_robots x 2
%       pr_robots_current   - positions of the real robots in the current
%                             iteration
%                             Matrix: n_robots x 2
%       iters_cc_converging - iterations to record the iterations that the
%                             current predator swrm robots have kept
%                             Scalar
% 
% OUTPUT:
%       converged           - Convergence status of the current predator
%                             swarm robots
%                             true: converged; false: not yet converged
%       iters_cc_converging - iterations to record the iterations that the
%                             current predator swrm robots have kept
%                             Scalar
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 7, 2018

%% define variables
% number of iterations of CC as the threshold to determine a convergence
THRESHOLD_CONVERGENCE = 10;

%% convergence status examination
if isequal(pr_robots_current,pr_robots_last)
    iters_cc_converging = iters_cc_converging + 1;
else
    iters_cc_converging = 0;
end
% END if isequal(pr_robots_current,pr_robots_last)

if iters_cc_converging >= THRESHOLD_CONVERGENCE
    converged = true;
else
    converged = false;
end
% END if iters_cc_converging >= THRESHOLD_CONVERGENCE

end