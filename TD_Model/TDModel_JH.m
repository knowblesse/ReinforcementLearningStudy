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
filename = uigetfile('.mat');% Experiment Schedule�� �ҷ��ɴϴ�.
load(filename);

%% Variables
% ������� �ٲ㵵 �Ǵ� ����
c = 0.1; % ������ 0.1, 0.2, 0.5 ������ �����.
alpha = 0.05; % ������ 0.6, 0.9 �� �����
beta = 0; % ������ ���� 0���� �������.
W0 = 0;% ������ ���� 0.6���� �������. �ʱ� Weight ��.

W1 = zeros(1,size(trials,1)); % �迭�� �̸� ����� �θ� for�� �ӵ��� �ö󰩴ϴ�. 
W2 = zeros(1,size(trials,1));
W1(1) = W0; % ù weight�� ��� W0 ���� ����.
W2(1) = W0; % ù weight�� ��� W0 ���� ����.
W_USC = 1; % UCS(US)�� ���� Weight�� �ִ�ġ 1 �Դϴ�.

CS1bar = zeros(1,size(trials,1)); % CS1�� Trace ��
CS2bar = zeros(1,size(trials,1)); % CS2�� Trace ��
UCSbar = zeros(1,size(trials,1)); % UCS�� Trace ��

Ybar = zeros(1,size(trials,1));
Y = zeros(1,size(trials,1));

%% Run
for t = 1 : size(trials,1)-1 % -1 �� �����־ ����� �����ϴ�.
    Y(t) = W1(t) * trials(t,1) + W2(t) * trials(t,2) + W_USC * trials(t,3); % Equation (1)
    CS1bar(t+1) = alpha * CS1bar(t) + trials(t,1); % Equation (3)
    CS2bar(t+1) = alpha * CS2bar(t) + trials(t,2); % Equation (3)
    UCSbar(t+1) = alpha * UCSbar(t) + trials(t,3); % Equation (3)
    Ybar(t+1) = beta * Ybar(t) + (1 - beta) * Y(t); % Equation (4)
    W1(t+1) = W1(t) + c * (Y(t) - Ybar(t)) * CS1bar(t); % Equation (5)
    W2(t+1) = W2(t) + c * (Y(t) - Ybar(t)) * CS2bar(t); % Equation (5)
end

%% Plot Trials : Experiment Schedule�� ���� �׷����� �׸��ϴ�.
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
%% Plot CS1 : CS1�� ���õ� ������ �׸��ϴ�.
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
%% Plot CS2 : CS2�� ���õ� ������ �׸��ϴ�.
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
%% Plot US : US�� ���õ� ������ �׸��ϴ�.
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