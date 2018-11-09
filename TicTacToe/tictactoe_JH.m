%% Tictactoe Model
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02

%% Initialize
clc; % Clear Command Window
clear; % Delete all variables
close; % Close all figures

%% Constants
NumberOfGamesToPlay = 1; % �÷����� ������ ��
IsPlayerOfXCOM = true; % X �÷��̾ ��ǻ�͸� true ����̸� false
IsPlayerOfOCOM = false; % O �÷��̾ ��ǻ�͸� true ����̸� false
Randomness_X = 0; % X �÷��̾��� Randomness
Randomness_O = 0; % O �÷��̾��� Randomness
Filename_Of_StateValue_File_X_Uses = 'Analysis/StateValue_30000Random.mat'; % X�� ��ǻ���� �� ����ϴ� StateValue ������ �̸�. ���δٸ� StateValue ���̺��� ������ ���Ҷ��� �Ʒ��� �ٸ� ���� �־��ش�.
Filename_Of_StateValue_File_O_Uses = 'Analysis/StateValue_10000Random20.mat'; % O�� ��ǻ���� �� ����ϴ� StateValue ������ �̸�. ���δٸ� StateValue ���̺��� ������ ���Ҷ��� ���� �ٸ� ���� �־��ش�.
PauseTime = 1; % ��ǻ�Ͱ� ���� �ΰ� ȭ�� ǥ�ø� �����ϴ� �ð�(��). ��ǻ�ͳ��� ������ �ο�� �ϰ� ���߿� ����� Ȯ���Ϸ��� �ϸ� 0���� �����ϸ� ���� ���ư���.

%% Load State Value
load('StateTable');
StateValue_X = load(Filename_Of_StateValue_File_X_Uses);
StateValue_X = StateValue_X.StateValue;
StateValue_O = load(Filename_Of_StateValue_File_O_Uses);
StateValue_O = StateValue_O.StateValue;
%% Start Games
for games = 1 : NumberOfGamesToPlay;
    clc;
    State = cell(2,9); % first row has it's index on StateTable, 2nd row has the State of the board
    Moves = zeros(1,9);
    CurrentState = 'EEEEEEEEE';
    %% Play Game
    fprintf('########## Game %d ##########\n',games);
    for i = 1 : 9
        if mod(i,2) == 1 % X's turn
            if IsPlayerOfXCOM % COM Makes Move
                % Make Move
                [Moves(i), newState] = makeMove(CurrentState, Randomness_X, StateTable, StateValue_X);
                % Substitution
                State{1,i} = findIndex(StateTable{1,i},newState);
                State{2,i} = newState;
                CurrentState = newState;
                % Print Current Situation
                fprintf(['----------Move ',num2str(i),'(X turn)----------\n==>My move : ',num2str(Moves(i)),'\n']);
                fprintf([newState(1:3),'\n',newState(4:6),'\n',newState(7:9),'\n']);
                fprintf('\n');
                pause(PauseTime);
            else % Get User Move
                % Make Move
                accept = false; % ���� �����ִ� ĭ�� ������ ���� �ƴ��� Ȯ���ϴ� ��.
                while ~accept
                    Moves(i) = input(['----------Move ',num2str(i),'(X turn)----------\n==>Your move : ']);
                    if any(Moves(i) == find(CurrentState ~= 'E'))
                        fprintf('Inccorect Move!!\n');
                    else
                        accept = true;
                    end
                end     
                newState = CurrentState;
                newState(Moves(i)) = 'X';
                % Substitution
                State{1,i} = findIndex(StateTable{1,i},newState);
                State{2,i} = newState;
                CurrentState = newState;
                % Print Current Situation
                fprintf([newState(1:3),'\n',newState(4:6),'\n',newState(7:9),'\n']);
                fprintf('\n');
            end
            % Check Winner
            if checkState(CurrentState) == 1 % X wins
                fprintf('------------------------------\n');
                fprintf('------------X  WIN------------\n');
                fprintf('------------------------------\n');
                break;
            elseif checkState(CurrentState) == 0 % O wins
                fprintf('------------------------------\n');
                fprintf('------------O  WIN------------\n');
                fprintf('------------------------------\n');
                break;
            end
        else % O's turn
            if IsPlayerOfOCOM % COM Makes Move
                % Make Move
                [Moves(i), newState] = makeMove(CurrentState, Randomness_O, StateTable, StateValue_O);
                % Substitution
                State{1,i} = findIndex(StateTable{1,i},newState);
                State{2,i} = newState;
                CurrentState = newState;
                % Print Current Situation
                fprintf(['----------Move ',num2str(i),'(O turn)----------\n==>My move : ',num2str(Moves(i)),'\n']);
                fprintf([newState(1:3),'\n',newState(4:6),'\n',newState(7:9),'\n']);
                fprintf('\n');
                 pause(PauseTime);
            else % Get User Move
                % Make Move
                accept = false; % ���� �����ִ� ĭ�� ������ ���� �ƴ��� Ȯ���ϴ� ��.
                while ~accept
                    Moves(i) = input(['----------Move ',num2str(i),'(O turn)----------\n==>Your move : ']);
                    if any(Moves(i) == find(CurrentState ~= 'E'))
                        fprintf('Inccorect Move!!\n');
                    else
                        accept = true;
                    end
                end 
                newState = CurrentState;
                newState(Moves(i)) = 'O';
                % Substitution
                State{1,i} = findIndex(StateTable{1,i},newState);
                State{2,i} = newState;
                CurrentState = newState;
                % Print Current Situation
                fprintf([newState(1:3),'\n',newState(4:6),'\n',newState(7:9),'\n']);
                fprintf('\n');
            end
            % Check Winner
            if checkState(CurrentState) == 1 % X wins
                fprintf('------------------------------\n');
                fprintf('------------X  WIN------------\n');
                fprintf('------------------------------\n');
                break;
            elseif checkState(CurrentState) == 0 % O wins
                fprintf('------------------------------\n');
                fprintf('------------O  WIN------------\n');
                fprintf('------------------------------\n');
                break;
            end
        end
    end
end