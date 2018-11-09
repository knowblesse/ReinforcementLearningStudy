function [ V ] = checkState( s )
%% 주어진 State에 대한 Value 값들을 초기화 시킵니다.
%   State를 보고 
%   X가 이긴 상태인 경우 1, 
%   O가 이긴 상태인 경우 0 을 출력합니다.
%   X와 O가 둘다 이긴 불가능한 상황의 경우 Error 값을 출력합니다.
%% checkState
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02

%% Initialize
state = reshape(s,3,3);
winner = []; 

%% Check whether someone win
% check winning by row
for row = 1 : 3 
    if strcmp(state(row,:),'OOO')
        winner = [winner,'O'];
    elseif strcmp(state(row,:),'XXX')
        winner = [winner,'X'];
    end
end
state = state';

% check winning by column
for col = 1 : 3 
    if strcmp(state(col,:),'OOO')
        winner = [winner,'O'];
    elseif strcmp(state(col,:),'XXX')
        winner = [winner,'X'];
    end
end

% Check winning by diagonal
if strcmp(s([1 5 9]),'OOO') || strcmp(s([3,5,7]),'OOO')
    winner = [winner,'O'];
elseif strcmp(s([1 5 9]),'XXX') || strcmp(s([3,5,7]),'XXX')
    winner = [winner,'X'];
end

%% Assign Output 
ERROR_VALUE = -1; % A value to assign to Invalid States
if isempty(winner)
    V = 0.5;% 승자가 없는 State에는 초기값 0.5
elseif length(unique(winner)) == 1
    if strcmp(winner(1), 'O')
        V = 0;
    else
        V = 1;
    end
else % more than 2 winners
    V = ERROR_VALUE;
end
end

