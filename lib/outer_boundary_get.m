function outer_boundary = outer_boundary_get(radius)
%% outer_boundary_get - get the outer boudary of the square space
% 
% DESCRIPTION:
%       The side length of the square is (2*@radius + 1).
%       What the function output is the following boundary:
%             -2    -2
%             -2    -1
%             -2     0
%             -2     1
%             -2     2
%              2    -2
%              2    -1
%              2     0
%              2     1
%              2     2
%             -2    -2
%             -1    -2
%              0    -2
%              1    -2
%              2    -2
%             -2     2
%             -1     2
%              0     2
%              1     2
%              2     2
%       for the following space:
% 
%       -------------------------------------------
%       (-2,2), | (-1,2),  (0,2),  (1,2), |  (2,2)
%       -------------------------------------------
%       (-2,1), | (-1,1),  (0,1),  (1,1), |  (2,1)
%       (-2,0), | (-1,0),  (0,0),  (1,0), |  (2,0)
%       (-2,-1),| (-1,-1), (0,-1), (1,-1),|  (2,-1)
%       -------------------------------------------
%       (-2,-2),| (-1,-2), (0,-2), (1,-2),|  (2,-2)
%       -------------------------------------------
% 
% 
% INPUT:
%       radius      - Scalar 
% 
% 
% OUTPUT:
%       boundary    - the outer boundary of a square space
%                     Matrix: (8*radius) x 2
% 
% 
% AUTHOR:
%       Lijun SUN
% 
% 
% DATE:
%      August 28, 2018

%% 
% num_potentials = (2*radius + 1)^2 - (2*(radius-1) + 1)^2;
num_elements = 8 * radius;
outer_boundary = zeros( num_elements ,2);
idx = 0;

%% 
x = -radius:1:radius;
y = -radius:1:radius;

%%
for ix = [1,2*radius+1]
    for iy = 1:(2*radius+1)
        idx = idx + 1;
        outer_boundary(idx,1) = x(ix);
        outer_boundary(idx,2) = y(iy);
    end
    % END for iy = 0:(2*radius+1)
end
% END for ix = [0,2*radius+1]

%%
for iy = [1,2*radius+1]
    for ix = 2:2*radius
        idx = idx + 1;
        outer_boundary(idx,1) = x(ix);
        outer_boundary(idx,2) = y(iy);
    end
    % END for iy = 0:(2*radius+1)
end
% END for ix = [0,2*radius+1]

end