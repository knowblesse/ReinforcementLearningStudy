function [ move, newState ] = makeMove( State, Randomness, StateTable, StateValue )
%% Make move by given policy selection option
%   Input parameter
%       char9 State : current State of the board
%       double randomness : probability of taking random move
%           1 : fully random
%           > 0 & < 1 : balanced
%           0 : fully greedy
%   Output parameter
%       int move : selected move
%       char9 newState : selected new State
%% makeMove
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02

rng('shuffle') %  Seed the random function

%% Check who'ss turn is it.
MoveN = 9 - sum(State == 'E') + 1;
if mod(MoveN,2) == 1 % : X's turn 
    turn = 'X';
else
    turn = 'O';
end

%% Generate Move
emptyIndexes = find(State == 'E');
newState = State;
if rand <= Randomness % random action selection
    move = emptyIndexes(randi(numel(emptyIndexes)));
    newState(move) = turn;
else % greedy action selection
    values = zeros(1,numel(emptyIndexes));
    for options = 1 : numel(emptyIndexes)
        candidateState = State;
        candidateState(emptyIndexes(options)) = turn;
        values(options) = StateValue{MoveN}(findIndex(StateTable{MoveN},candidateState));
    end
    if turn == 'X'
        [~,index] = max(values); % Select Move which has the highest value => 1 = X wins
    else
        [~,index] = min(values); % Select Move which has the lowest value => 0 = O wins
    end
    move = emptyIndexes(index);
    newState(move) = turn;
end
end

