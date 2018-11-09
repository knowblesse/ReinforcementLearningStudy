function [ data1 data2 ] = RunBandit( learnFromAverage, learningRate, usingSoftMax, tau, numberOfLearning, randomness)
% Run Bandit from given parameters
%   Detailed explanation goes here

%% JEONG_JIHOON
%   @Knowblesse
%   Created on 2016-11-23
%   Last Modified on 2016-11-23

%% Bandit Option
N = 10; % number of the choices
mu = 1 : 10; % mu values of each arm
rng('Shuffle'); % initialize the random function
q = randperm(N); % true value of the arm
noise_mean = 0;
noise_sigma = 1;

%% Learner's Charicteristics
Q = zeros(1,N); % estiamtes of each arm

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
%% Return Data
data1 = outcome(:,2);
window = 100;
windowedAverage = reshape(outcome(:,2),10,numberOfLearning/10)';
data2 = mean(windowedAverage,2);
end

