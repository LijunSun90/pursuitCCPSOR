function frame = movie_record(f)
%movie_record - record the movie of the animation
%-------------------------------------------------------------------------
% INPUT:
%       f           - handle of a figure window
%                     matlab.ui.Figure
%  
% OUTPUT:
%       frame       - the recorded frames
%                     struct
% 
% AUTHOR:
%       Lijun SUN
%-------------------------------------------------------------------------

%% change the fiugre units to pixels and return the current axes position
% f.Units = 'pixels';
% pos = f.Position;

%% create a four-element vector, rect, that defines a rectangular area 
% rect = [0, 0, pos(3), pos(4)];
% frame = getframe(f,rect);
% f.Units = 'normalized';
frame = getframe(f.CurrentAxes);

end