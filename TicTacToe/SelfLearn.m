function [ newStateValue, XWin ] = SelfLearn( StateTable, StateValue, LearningRate, Randomness )
%% �־��� ������ ���� ȥ�� ������ ������ ����� StateValue�� ����Ѵ�.
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
        State{1,i} = findIndex(StateTable{1,i},newState); % ���� Move�� �ش�Ǵ� State�� Index���� �Է�(9���� Text�� Table������ ��ġ)
        State{2,i} = newState; % ���� Move�� �ش�Ǵ� State�� �Է�(9���� Text)
        CurrentState = newState;
        % UpdateStateValue
        if i >= 3 % X �����̸� 3��° �� (X�� �ι�° ������ Update�� ����)
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
        if i >= 4 % O �����̸� 4��° �� (O�� �ι�° ������ Update�� ����)
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