function f = map_create(map_w,map_h,grid_on,visible)
%map_create - create the map
%-------------------------------------------------------------------------
% 
% INPUT:
%       map_w       - width of the map
%                     Scalar
%       map_h       - height of the map
%                     Scalar
%       grid_on     - the flag to set grid on or off
%                     true (default): grid on; false: grid off
%       visible     - the flag to set the figure visible or not
%                     true (default): visible on; false: visible off
% 
% 
% OUTPUT:
%       f           - the created figure object
% 
% 
% AUTHOR:
%       Lijun SUN
%-------------------------------------------------------------------------

%% check input paramters
if nargin < 4
    visible = true;
end
% END if nargin < 4

if nargin < 3
    grid_on = true;
end
% END if nargin < 3

%% create the map
if visible
    f = figure('Name','simulation_map'); 
else
    f = figure('Name','simulation_map','Visible','off'); 
end
% END if visible

pbaspect([map_w, map_h, 1]); 
xlim([0.5,map_w+0.5]); ylim([0.5,map_h+0.5]);

if grid_on
    set(f.CurrentAxes,'xtick',(0.5:1:map_w+0.5),...
                      'ytick',(0.5:1:map_h+0.5),...
                      'xticklabel',[],'yticklabel',[],...
                      'xgrid','on','ygrid','on',...
                      'GridLineStyle','-','GridAlpha',0.8,'GridColor','k');
else
    set(f.CurrentAxes,'xtick',[],'ytick',[],...
                      'xticklabel',[],'yticklabel',[],'box','on'); 
end
% END if grid_on

end