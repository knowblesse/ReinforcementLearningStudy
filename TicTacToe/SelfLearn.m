function [ newStateValue, XWin ] = SelfLearn( StateTable, StateValue, LearningRate, Randomness )
%% 주어진 변수를 토대로 혼자 게임을 진행해 변경된 StateValue를 출력한다.
%% SelfLearn
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02
%% Initialize
State = cell(2,9); % first row has it's index on StateTable, 2nd row has the State of the board
Moves = zeros(1,9);
CurrentState = 'EEEEEEEEE';
%% Play Game
for i = 1 : 9
    if mod(i,2) == 1 % X's turn
        % Make Move
        [Moves(i), newState] = makeMove( CurrentState, Randomness, StateTable, StateValue );
        % Substitution
        State{1,i} = findIndex(StateTable{1,i},newState); % 현재 Move에 해당되는 State의 Index값을 입력(9글자 Text의 Table에서의 위치)
        State{2,i} = newState; % 현재 Move에 해당되는 State를 입력(9글자 Text)
        CurrentState = newState;
        % UpdateStateValue
        if i >= 3 % X 차례이면 3번째 수 (X의 두번째 수부터 Update가 진행)
            StateValue{i-2}(State{1,i-2}) = StateValue{i-2}(State{1,i-2}) + LearningRate * (StateValue{i}(State{1,i}) - StateValue{i-2}(State{1,i-2}));
        end
        % Check Winner
        if checkState(CurrentState) == 1 || checkState(CurrentState) == 0
            break;
        end
    else % O's turn
        % Make Move
        [Moves(i), newState] = makeMove( CurrentState, Randomness, StateTable, StateValue );
        % Substitution
        State{1,i} = findIndex(StateTable{1,i},newState);
        State{2,i} = newState;
        CurrentState = newState;
        % UpdateStateValue
        if i >= 4 % O 차례이면 4번째 수 (O의 두번째 수부터 Update가 진행)
            StateValue{i-2}(State{1,i-2}) = StateValue{i-2}(State{1,i-2}) + LearningRate * (StateValue{i}(State{1,i}) - StateValue{i-2}(State{1,i-2}));
        end
        % Check Winner
        if checkState(CurrentState) == 1 || checkState(CurrentState) == 0
            break;
        end
    end
end
if checkState(CurrentState) == 1
    XWin = 1;
elseif checkState(CurrentState) == 0
    XWin = 0;
else
    XWin = 0.5;
end
newStateValue = StateValue;
end