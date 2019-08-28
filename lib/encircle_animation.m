%% encircle_animation -
% 
% DESCRIPTION:
%       Create animation for the encircle experiment.
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       Dec 6, 2018

%%
figure(f);

% clear
clearpoints(ani_robots);
clearpoints(ani_virtual_robots);
clearpoints(ani_target);

% add points for real robots
addpoints(ani_robots,p_robots(:,1,1), p_robots(:,2,1));

% add points for virtual robots
for i_robot = 1:n_robots
    addpoints(ani_virtual_robots,squeeze(p_robots(i_robot,1,2:pop_sz)),...
        squeeze(p_robots(i_robot,2,2:pop_sz)));
end
% END for i_robot = 1:n_robots

% add points for the target
addpoints(ani_target, p_target(:,1), p_target(:,2));

% title
% title("iter\_cc = " + num2str(iter_cc));
set(ht,'String',iter_cc);
drawnow;

% record
frames(iter_cc+1) = movie_record(f);
