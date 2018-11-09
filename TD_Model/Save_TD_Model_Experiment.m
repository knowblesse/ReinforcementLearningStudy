%% Save_TD_Model_Experiment
%   @knowblesse
%   Created on : 2016-10-05
%   Last Modified on : 2016-10-11
%
%% Initialize
clc; % Clear Command Window
clear; % Delete all variables
close; % Close all figures
%% TD Basic
% CS와 US의 제시 시간에 따라서 이 값을 조정할 것.
trials = [] ;% col1 : CS1 | col2 : CS2 | col3 : UCS // 0 for +, 1 for -
trials = zeros(60,3); % Create array of 60 second "single" trial
trials(1:10,1) = true; % First 10 sec => CS1 on
trials(11:40,3) = true; % After CS Offset, US is on for 30 sec duration.

numOfSessions = 50; % How many times to repeat the above experiment

trials = repmat(trials,numOfSessions,1);
clear numOfSessions;
save('TDModelBasic.mat');

%% TD Extincion
trials = [] ;
%Session1
session1 = zeros(60,3);
session1(1:10,1) = true;
session1(11:40,3) = true;

numOfSessions = 50; 
session1 = repmat(session1,numOfSessions,1);

%Session2
session2 = zeros(60,3);
session2(1:10,1) = true;

numOfSessions2 = 50;
session2 = repmat(session2,numOfSessions2,1);

trials = [session1; session2];
clear numOfSessions session1 session2; 
save('TDModelExt.mat');

%% TD Blocking
trials = [] ;
%Session1
session1 = zeros(60,3);
session1(1:10,1) = true;
session1(11:40,3) = true;

numOfSessions = 50; 
session1 = repmat(session1,numOfSessions,1);

%Session2
session2 = zeros(60,3);
session2(1:10,1:2) = true;
session1(11:40,3) = true;

numOfSessions2 = 50;
session2 = repmat(session2,numOfSessions2,1);

trials = [session1; session2];
clear numOfSessions session1 session2;
save('TDModelBlocking.mat');

%% TD Second
trials = [] ;
%Session1
session1 = zeros(40,3);
session1(1:10,1) = true; 
session1(11:40,3) = true;
numOfSessions = 50;
session1 = repmat(session1,numOfSessions,1);

%Session2
session2 = zeros(80,3);
session2(5 : 20, 2) = true;
session2(21 : 40, 1) = true;

numOfSessions2 = 50;
session2 = repmat(session2,numOfSessions2,1);

trials = [session1; session2];
clear numOfSessions session1 session2;
save('TDModelSecond.mat');