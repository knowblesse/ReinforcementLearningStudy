function [ V ] = checkState( s )
%% �־��� State�� ���� Value ������ �ʱ�ȭ ��ŵ�ϴ�.
%   State�� ���� 
%   X�� �̱� ������ ��� 1, 
%   O�� �̱� ������ ��� 0 �� ����մϴ�.
%   X�� O�� �Ѵ� �̱� �Ұ����� ��Ȳ�� ��� Error ���� ����մϴ�.
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
    V = 0.5;% ���ڰ� ���� State���� �ʱⰪ 0.5
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

