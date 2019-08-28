function p_out = within_scope(p_in,p_center,radius)
%% within_scope - 
%-------------------------------------------------------------------------
% DESCRIPTION:
%       Restrict the position of each virtual robot to a fixed radius of
%       the real robots. 
% 
% INPUT:
%       p_in        - the input position
%                     Matrix: 1 x 2
%       p_center    - the position of the scope center
%                     Matrix: 1 x 2
%       radius      - the raidus around the center within which @p_in are 
%                     allowed to be distributed
%                     Scalar
% 
% OUTPUT:
%       p_out       - the position in the scope which is nearest to p_in if
%                     p_in is out of the scope; otherwise, it is p_in.
%                     Matrix: 1 x 2
% 
% AUTHOR:
%       Lijun SUN
% 
% DATE:
%       August 28, 2018
%-------------------------------------------------------------------------

%% check and deal if p_in is in the radius scope of p_center
if abs(p_in(1)-p_center(1))<=radius && abs(p_in(2)-p_center(2))<=radius 
    % within the scope
    p_out = p_in;
else
    % out of the scope and thus choose a nearest neighbor boundary (NNB)
    p_out = NNB_get(p_in,p_center,radius);
end
% END if p_in(1)-p_center(1)<radius || p_in(2)-p_center(2)<radius 

end