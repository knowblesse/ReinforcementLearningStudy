%% N_arm_bandit Problem
%   Jeong Ji Hoon
%   ST_ID : 2016010980

%% JEONG_JIHOON
%   @Knowblesse
%   Created on 2016-11-09
%   Last Modified on 2016-11-23

%% Initialization
clear; % close workspace
clear;
close all; % close all figures
clc; % close command window (output window of Matlab)

%% Bandit Option
N = 10; % number of the choices
mu = 1 : 10; % mu values of each arm
rng('Shuffle'); % initialize the random function
q = randperm(N); % true value of the arm
noise_mean = 0;
noise_sigma = 1;

%% Learner's Charicteristics
learnFromAverage = true;
learningRate = 0.3;

usingSoftMax = false;
tau = 0.8;

Q = zeros(1,N); % estiamtes of each arm

numberOfLearning = 2000;
randomness = 0.05;

accumResult = Q;
accumResult(2,1:N) = ones(1,N);

outcome = zeros(numberOfLearning,2); % Col 1 ; estimation | Col 2 : actual result

%% Execute Learning
for learn = 1 : numberOfLearning
    %% Action Selection
    if rand <= randomness % go random : Exploration
        if usingSoftMax % Selete using Softmax algorithm,
            Qe = exp(Q./tau);
            Qe = Qe ./ sum(Qe);
            selection = sum(rand >= cumsum([0,Qe])); % select action from pmf
        else % just select the arm with equal pmf.
            selection = randi(10);
        end
    else % go greedy : Exploitation
        [outcome(learn,1), index] = max(Q);
        if sum(Q == max(Q)) ~= 1 % more than two maximum values
            indexes = find(max(Q) == outcome(learn,1));
            selection = indexes(randi(numel(indexes)));
        else % only one maximum value
            selection = index;
        end
    end
    %% Result of the Action
    outcome(learn,2) = q(selection) + normrnd(noise_mean,noise_sigma);
    %% Change the q_estimates
    if learnFromAverage % learn from accumulated result of the selected arm
        accumResult(2,selection) = accumResult(2,selection) + 1;
        accumResult(1,selection) = accumResult(1,selection) + outcome(learn,2); 
        Q(selection) = accumResult(1,selection) / accumResult(2,selection);
    else % learn from difference b/w expectation and the result
        Q(selection) =  Q(selection) + learningRate * (outcome(learn,2) - outcome(learn,1));
    end
end
%% Print Real q
for i = 1 : 10
    fprintf(['q',num2str(i),' : %f | '],q(i));
end
fprintf('\n');
%% Print Estimated Q
for i = 1 : 10
    fprintf(['Q',num2str(i),' : %3f | '],Q(i));
end
fprintf('\n');
%% Plot Data
figure(1);
plot(outcome(:,2));
axis([-inf,inf,0,12]);
window = 100;
windowedAverage = reshape(outcome(:,2),10,numberOfLearning/10)';
hold on;
figure(2);
plot(mean(windowedAverage,2));
axis([-inf,inf,0,12]);
hold on;
figure(3);
movmean = [];
for i = 1 : numel(outcome(:,2)) - 99
    movmean = [movmean, mean(outcome(i:i+window-1,2))];
end
plot(movmean);
axis([-inf,inf,0,12]);
hold on;