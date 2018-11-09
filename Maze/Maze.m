%% Maze
%   Jeong Ji Hoon
%   ST_ID : 2016010980

%% JEONG_JIHOON
%   @Knowblesse
%   Created on 2016-11-30
%   Last Modified on 2016-11-30

%% Initialization
clear; % close workspace
clear;
clc; % close command window (output window of Matlab)

%% Constants
V_livingPenalty = - 0.1;
V_Goal = 1;
V_FirePit = -1;
P_CorrectMovement = 0.8;

%% Create Maze
MAZE = V_livingPenalty * ones(3,4);
MAZE(2,2) = 0; %Wall;
MAZE(1,4) = V_Goal;
MAZE(2,4) = V_FirePit;

%% Compute Policy Map
% Direction 
% 1 : North | 2 : East | 3 : South | 4 : West
Q = zeros(1,4); % Estimated Reward for each Direction Selection
Actions = zeros(3,4);
for row = 1 : size(MAZE,1);
    for col = 1 : size(MAZE,2);
        % Setup the Rounds
        Rounds = zeros(1,4);
        if row ~= 1
            Rounds(1) = MAZE(row-1,col);
        end
        if col ~= size(MAZE,2)
            Rounds(2) = MAZE(row, col+1);
        end
        if row ~= size(MAZE,1)
            Rounds(3) = MAZE(row+1,col);
        end
        if col ~= 1
            Rounds(4) = MAZE(row,col-1);
        end
        Q(1) = Rounds(1) * P_CorrectMovement + (Rounds(2) + Rounds(4)) * (1-P_CorrectMovement);
        Q(2) = Rounds(2) * P_CorrectMovement + (Rounds(1) + Rounds(3)) * (1-P_CorrectMovement);
        Q(3) = Rounds(3) * P_CorrectMovement + (Rounds(2) + Rounds(4)) * (1-P_CorrectMovement);
        Q(4) = Rounds(4) * P_CorrectMovement + (Rounds(1) + Rounds(3)) * (1-P_CorrectMovement);
        [values, action] = max(Q);
        Actions(row,col) = action;
    end
end

        

