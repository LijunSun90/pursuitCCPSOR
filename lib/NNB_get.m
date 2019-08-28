function p_boundary = NNB_get(p_in,p_center,radius)
%% NNB_get - get the nearest neighbor boundary (NNB)
%-------------------------------------------------------------------------
% DESCRIPTION:
%       if @radius = 2, @outer_boundary will like this:
% 
%         -2    -2
%         -2    -1
%         -2     0
%         -2     1
%         -2     2
%          2    -2
%          2    -1
%          2     0
%          2     1
%          2     2
%         -1    -2
%          0    -2
%          1    -2
%         -1     2
%          0     2
%          1     2
%       
%       which is the vector of the following outer squre boundary:
% 
%       -2,2    -1,2    0,2     1,2     2,2
%       -2,1                            2,1
%       -2,0                            2,0
%       -2,-1                           2,-1
%       -2,-2   -1,-2   0,-2    1,-2    2,-2
% 
% INPUT:
%       p_in        - the input position
%                     Matrix: 1 x 2
%       p_center    - the position of the square scope center
%                     Matrix: 1 x 2
%       radius      - the raidus or half side length of the square scope
%                     Scalar
% 
% OUTPUT:
%       p_boundary  - the nearest neighbor boundary (NNB) to p_center in 
%                     the direction of (p_in - p_center)
%                     Matrix: 1 x 2
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%      August 28, 2018
%-------------------------------------------------------------------------

%% get the outer boundary
% num_potentials = (2*radius + 1)^2 - (2*(radius-1) + 1)^2;
num_elements = 8 * radius;
outer_boundary = zeros( num_elements ,2);
%
x = -radius:1:radius;
y = -radius:1:radius;
[xx,yy] = meshgrid(x,y);
%
outer_boundary(1:(2*radius+1), :) = [xx(:,1),yy(:,1)];
outer_boundary((2*radius+2):(4*radius+2), :) = [xx(:,end),yy(:,end)];
outer_boundary((4*radius+3):(6*radius+1), :) = ...
                                        [xx(1,2:end-1).',yy(1,2:end-1).'];
outer_boundary((6*radius+2):end, :) = ...
                                    [xx(end,2:end-1).',yy(end,2:end-1).'];


%% boundary angle
angle_boundary = atan2(outer_boundary(:,2),outer_boundary(:,1));

%% reference angle
p_diff = p_in - p_center;
angle_reference = atan2(p_diff(2), p_diff(1));

%% find the neareast neighbor boundary (NNB)
angle_diff = abs(angle_reference - angle_boundary);
[~,idx] = min(angle_diff);
p_NNB = outer_boundary(idx,:);

%% output
p_boundary = p_center + p_NNB;

end