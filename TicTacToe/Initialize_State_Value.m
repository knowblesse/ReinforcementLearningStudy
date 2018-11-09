%% Initialize_State_Value
%   @knowblesse
%   Created on : 2016-11-02
%   Last Modified on : 2016-11-02
%   State�� ���� Value ������ �ʱ�ȭ ��ŵ�ϴ�.
%   ��� �ڵ�� X�� �̱�� ������ 1�̰� O�� �̱�� ������ 0 �Դϴ�.

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

