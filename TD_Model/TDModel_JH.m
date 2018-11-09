%% TD Model
%   @knowblesse
%   Created on : 2016-10-05
%   Last Modified on : 2016-10-19
%

%% Initialize
clc; % Clear Command Window
clear; % Delete all variables
close; % Close all figures

%% load Experimental Conditions
filename = uigetfile('.mat');% Experiment Schedule을 불러옵니다.
load(filename);

%% Variables
% 마음대로 바꿔도 되는 값들
c = 0.1; % 논문에서 0.1, 0.2, 0.5 등으로 사용함.
alpha = 0.05; % 논문에서 0.6, 0.9 로 사용함
beta = 0; % 논문에서 전부 0으로 사용했음.
W0 = 0;% 논문에서 전부 0.6으로 사용했음. 초기 Weight 값.

W1 = zeros(1,size(trials,1)); % 배열을 미리 만들어 두면 for문 속도가 올라갑니다. 
W2 = zeros(1,size(trials,1));
W1(1) = W0; % 첫 weight는 모두 W0 값을 대입.
W2(1) = W0; % 첫 weight는 모두 W0 값을 대입.
W_USC = 1; % UCS(US)에 대한 Weight은 최대치 1 입니다.

CS1bar = zeros(1,size(trials,1)); % CS1의 Trace 값
CS2bar = zeros(1,size(trials,1)); % CS2의 Trace 값
UCSbar = zeros(1,size(trials,1)); % UCS의 Trace 값

Ybar = zeros(1,size(trials,1));
Y = zeros(1,size(trials,1));

%% Run
for t = 1 : size(trials,1)-1 % -1 을 안해주어도 상관은 없습니다.
    Y(t) = W1(t) * trials(t,1) + W2(t) * trials(t,2) + W_USC * trials(t,3); % Equation (1)
    CS1bar(t+1) = alpha * CS1bar(t) + trials(t,1); % Equation (3)
    CS2bar(t+1) = alpha * CS2bar(t) + trials(t,2); % Equation (3)
    UCSbar(t+1) = alpha * UCSbar(t) + trials(t,3); % Equation (3)
    Ybar(t+1) = beta * Ybar(t) + (1 - beta) * Y(t); % Equation (4)
    W1(t+1) = W1(t) + c * (Y(t) - Ybar(t)) * CS1bar(t); % Equation (5)
    W2(t+1) = W2(t) + c * (Y(t) - Ybar(t)) * CS2bar(t); % Equation (5)
end

%% Plot Trials : Experiment Schedule에 대한 그래프를 그립니다.
figure(1);
clf;
subplot(3,1,1);
plot(trials(:,1));
title('CS1');
hold on;
subplot(3,1,2);
plot(trials(:,2));
title('CS2');
subplot(3,1,3);
plot(trials(:,3));
title('UCS');
%% Plot CS1 : CS1에 관련된 값들을 그립니다.
figure(2);
clf;
subplot(3,1,1);
plot(trials(:,1));
axis([0,size(trials,1), 0, inf]);
title('CS1');
hold on;
subplot(3,1,2);
plot(CS1bar);
axis([0,size(trials,1), 0, inf]);
title('CS1bar');
subplot(3,1,3);
axis([0,size(trials,1), 0, inf]);
plot(W1);
title('W1');
%% Plot CS2 : CS2에 관련된 값들을 그립니다.
figure(3);
clf;
subplot(3,1,1);
plot(trials(:,2));
axis([0,size(trials,1), 0, inf]);
title('CS2');
hold on;
subplot(3,1,2);
plot(CS2bar);
axis([0,size(trials,1), 0, inf]);
title('CS2bar');
subplot(3,1,3);
axis([0,size(trials,1), 0, inf]);
plot(W2);
title('W2');
%% Plot US : US에 관련된 값들을 그립니다.
figure(4);
clf;
subplot(3,1,1);
plot(trials(:,3));
axis([0,size(trials,1), 0, inf]);
title('US');
hold on;
subplot(3,1,2);
plot(Ybar);
axis([0,size(trials,1), 0, inf]);
title('Ybar');
subplot(3,1,3);
plot(Y);
axis([0,size(trials,1), 0, inf]);
title('Y');        