function ani = ...
    animation_create(ani_marker,ani_marker_size,ani_marker_color)
%animation_create - create the animation object
% ------------------------------------------------------------------------
% 
% INPUT:
%       ani_marker           - marker style  
%                              String
%       ani_marker_size      - marker size
%                              Scalar
%       ani_marker_color     - marker color
%                              String
% 
% 
% OUTPUT:
%       ani                  - animation
%                              matlab.graphics.animation.AnimatedLine
% 
% 
% AUTHOR:
%       Lijun SUN
% ------------------------------------------------------------------------

%% create animation and set its parameters
ani = animatedline; ani.LineStyle = 'None';
ani.Marker = ani_marker; 
ani.MarkerSize = ani_marker_size; 
ani.MarkerFaceColor = ani_marker_color; 
ani.MarkerEdgeColor = ani_marker_color;  

end