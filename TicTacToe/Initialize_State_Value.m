%% Initialize_State_Value
%   @knowblesse
%   Created on : 2016-11-02
%   Last Modified on : 2016-11-02
%   State에 대한 Value 값들을 초기화 시킵니다.
%   모든 코드는 X가 이기는 조건이 1이고 O가 이기는 조건이 0 입니다.

%% Initialization
clear; % close workspace
clear;
close all; % close all figures
clc; % close command window (output window of Matlab)

%% Load State Table
load('StateTable.mat');

%% Assign values of 1 xor 0 to win xor lose state
StateValue = cell(1,9);
for c = 1 : 9
    for row = 1 : size(StateTable{c},1)
        StateValue{c}(row) = checkState(StateTable{c}(row,:));
    end
end
uisave('StateValue','StateValue.mat');
clear c row;

