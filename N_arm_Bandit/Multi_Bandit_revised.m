%% Multi-bandit
%   Jeong Ji Hoon
%   ST_ID : 2016010980

%% JEONG_JIHOON
%   @Knowblesse
%   Created on 2016-11-09
%   Last Modified on 2016-11-23

%% Initialization
clear; % close workspace
clear;
clc; % close command window (output window of Matlab)

%% Run Bandit for N times
accumData1 = []; % ������ ������ ���� ��� ����
accumData2 = []; % ������ ��� ������ ���� ��� ����

%% ������ �� �ִ� ������
% �⺻���� ����
numberOfLearning = 1500; % arm�� ���� ���� ��

% Random �� �� ��� �����ұ�?
usingSoftMax = true; % true : Softmax ��� | false : e-greedy ���
randomness = 0.05; % e-greedy ��� �϶� eplison ��.
tau = 0.1; % Softmax �϶� �µ� t ��.

% ���� arm�� ���� �˰� �Ǿ��� �� �ش� arm�� ����� ��� �����ұ�?
learnFromAverage = true; % true : �ش� arm���� ���� ������ ��� ������� ���� | false : Rescola-W ������� ����
learningRate = 0.3; % Rescola �϶� learning rate


tic
for i = 1 : 50
    [data1, data2] = RunBandit( learnFromAverage, learningRate, usingSoftMax, tau, numberOfLearning, randomness);
    accumData1 = [accumData1, data1];
    accumData2 = [accumData2, data2];
end
toc

fig = figure(1);
clf;
subplot(2,1,1);
plot(mean(accumData1,2));
axis([-inf, inf, 0, 12]);
title(['SoftMax : ', num2str(usingSoftMax), ' Avr : ', num2str(learnFromAverage), ' alpha : ', num2str(learningRate), ' tau : ', num2str(tau)]);

subplot(2,1,2);
plot(mean(accumData2,2));
axis([-inf, inf, 0, 12]);
----