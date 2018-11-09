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
accumData1 = []; % 누적된 데이터 값을 담는 변수
accumData2 = []; % 누적된 평균 데이터 값을 담는 변수

%% 수정할 수 있는 변수들
% 기본적인 변수
numberOfLearning = 1500; % arm을 당기는 시행 수

% Random 일 때 어떻게 선택할까?
usingSoftMax = true; % true : Softmax 방식 | false : e-greedy 방식
randomness = 0.05; % e-greedy 방식 일때 eplison 값.
tau = 0.1; % Softmax 일때 온도 t 값.

% 실제 arm의 값을 알게 되었을 때 해당 arm의 기댓값을 어떻게 수정할까?
learnFromAverage = true; % true : 해당 arm에서 나온 값들의 평균 방식으로 수정 | false : Rescola-W 방식으로 수정
learningRate = 0.3; % Rescola 일때 learning rate


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