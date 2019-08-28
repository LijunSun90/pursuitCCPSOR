function r = radius_calculate(pop_sz)
%radius_calculate - 
%-------------------------------------------------------------------------
% 
% DESCRIPTION:
%       Calculate the minimum radius based on the @pop_sz of each  
%       subpopulation, such that the square neighborhood of the center 
%       position can conclude @pop_sz unique robots.
% 
% INPUT:
%       pop_sz      - the population size
%                     Scalar
%   
% OUTPUT:
%       r           - the minimum radius described above
%                     Scalar
% 
% AUTHOR:
%       Lijun SUN
%-------------------------------------------------------------------------

%% initialization
r = 1;
include_all = false;

%% loop
while ~include_all 
    if ( (2*r + 1)^2 ) >= pop_sz
        include_all = true;
    else
        % update
        r = r + 1;
    end
    % END if ( (2*r + 1)^2 ) >= pop_sz
end
% END while ~included

end