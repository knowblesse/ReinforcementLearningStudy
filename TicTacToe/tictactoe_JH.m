%% Tictactoe Model
%   @knowblesse
%   Created on : 2016-10-20
%   Last Modified on : 2016-11-02

%% Initialize
clc; % Clear Command Window
clear; % Delete all variables
close; % Close all figures

%% Constants
NumberOfGamesToPlay = 1; % 플레이할 게임의 수
IsPlayerOfXCOM = true; % X 플레이어가 컴퓨터면 true 사람이면 false
IsPlayerOfOCOM = false; % O 플레이어가 컴퓨터면 true 사람이면 false
Randomness_X = 0; % X 플레이어의 Randomness
Randomness_O = 0; % O 플레이어의 Randomness
Filename_Of_StateValue_File_X_Uses = 'Analysis/StateValue_30000Random.mat'; % X가 컴퓨터일 때 사용하는 StateValue 파일의 이름. 서로다른 StateValue 테이블끼리 성능을 비교할때만 아래와 다른 값을 넣어준다.
Filename_Of_StateValue_File_O_Uses = 'Analysis/StateValue_10000Random20.mat'; % O가 컴퓨터일 때 사용하는 StateValue 파일의 이름. 서로다른 StateValue 테이블끼리 성능을 비교할때만 위와 다른 값을 넣어준다.
PauseTime = 1; % 컴퓨터가 수를 두고 화면 표시를 유지하는 시간(초). 컴퓨터끼리 여러번 싸우게 하고 나중에 결과를 확인하려고 하면 0으로 설정하면 빨리 돌아간다.

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
                accept = false; % 돌이 놓여있는 칸을 선택한 것은 아닌지 확인하는 값.
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
                accept = false; % 돌이 놓여있는 칸을 선택한 것은 아닌지 확인하는 값.
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