function v_one_step = one_step_direction(v)
%one_step_direction - select the closest one step direction of v
%-------------------------------------------------------------------------
%
% DESCRIPTION:
%       *   *     *     *   *
%       * dir_4 dir_3 dir_2 *
%       * dir_5   #   dir_1 *
%       * dir_6 dir_7 dir_8 *
%       *   *     *     *   *
% 
%       In a grid map, each robot # has eight neighbors where it can go in
%       one step, such that the velocity of each step can be represented as
%       a vector.
% 
%       This function is used to choose one of the eight vectors
%       {dir_1, ..., dir_8} which has the minimum angle with each member of
%       v.
% 
%       Note if v(ix) = [0,0], this function will randomly choose one of 
%       the eight vectors {dir_1, ..., dir_8}, in case it can find a more
%       better position. If the new position is worse, the fitness function
%       will prevent the generation update. So, this strategy won't worsen
%       the result.
% 
% 
% INPUT:
%       v          - a vector whose members are a velocity
%                    Matrix: n_robots x n_dim x pop_sz
% 
% 
% OUTPUT:
%       v_one_step - the the closest one step direction of v
%                    Matrix: n_robots x n_dim x pop_sz
% 
% 
% AUTHOR:
%       Lijun SUN
%-------------------------------------------------------------------------

%% define variables
[n_robots,~,pop_sz] = size(v);

%% the vectors of all the one step away neighbors:
% 8x2
vs_one_step = [1,0; 1,1; 0,1; -1,1; -1,0; -1,-1; 0,-1; 1,-1];
% 4x2
% vs_one_step = [1,0; 0,1; -1,0; 0,-1];

%% the direction of each neighbor vector: 8x1
% angle_vs = atan2(vs_one_step(:,2,:), vs_one_step(:,1,:));
% 8x1
angle_vs =[0; 0.7854; 1.5708; 2.3562; 3.1416; -2.3562; -1.5708; -0.7854];
% 4x1
% angle_vs = [0; 1.5708; 3.1416; -1.5708];

%% calculate the pariwise angle between each of v and each of vs_one_step
v_one_step = v;
angle_v = atan2(v(:,2,:), v(:,1,:));
for i_robot = 1:n_robots
    for individual = 1:pop_sz
        if angle_v(i_robot,:,individual) == 0
            idx = randi(8,1);          
        else
            angle = abs( angle_v(i_robot,:,individual) - angle_vs );

            % find the minimum angle, its indice and the v_one_step
            [~, idx] = min(angle);
        end
        % END angle_v(i_robot,:,individual) == 0  
        
        % update 
        v_one_step(i_robot,:,individual) = vs_one_step(idx,:);
    end
    % END for individual = 1:pop_sz
end
% END for i_robot = 1:n_robots

%% test
% figure
% plot(vs_one_step(:,1),vs_one_step(:,2),'bx');
% v_x = v(1,1,:); v_y = v(1,2,:);
% hold on; plot(v_x(:),v_y(:),'r*');
% v_one_step_x = v_one_step(1,1,:); v_one_step_y = v_one_step(1,2,:); 
% hold on; plot(v_one_step_x(:),v_one_step_y(:),'ro');
% hold on; plot(0,0,'gp')
% axis equal; grid on;

end