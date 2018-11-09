%% Single Layer Neural Network
%   @knowblesse
%   Created on : 2016-09-27
%   Last Modified on : 2016-10-07
%% Layer Characteristics
tic;
N_inputNode = 15; % number of input nodes
N_outputNode = 10; % number of output nodes
LearningRate = 0.2; % learning rate in every iterations
%% Training Set
% TrainingSet_input = [...
%     0 0;...
%     0 1;...
%     1 0;...
%     1 1 ];
% TrainingSet_output = [...
%     0;
%     1;
%     1;
%     1 ];
TrainingSet_input = [ ...
    1 1 1 1 0 1 1 0 1 1 0 1 1 1 1;...
    0 1 0 1 1 0 0 1 0 0 1 0 1 1 1;...
    1 1 1 0 0 1 1 1 1 1 0 0 1 1 1;...
    1 1 1 0 0 1 1 1 1 0 0 1 1 1 1;...
    1 0 1 1 0 1 1 1 1 0 0 1 0 0 1;...
    1 1 1 1 0 0 1 1 1 0 0 1 1 1 1;...
    1 1 1 1 0 0 1 1 1 1 0 1 1 1 1;...
    1 1 1 0 0 1 0 0 1 0 0 1 0 0 1;...
    1 1 1 1 0 1 1 1 1 1 0 1 1 1 1;...
    1 1 1 1 0 1 1 1 1 0 0 1 1 1 1];

TrainingSet_output = [...
    1 0 0 0 0 0 0 0 0 0;...
    0 1 0 0 0 0 0 0 0 0;...
    0 0 1 0 0 0 0 0 0 0;...
    0 0 0 1 0 0 0 0 0 0;...
    0 0 0 0 1 0 0 0 0 0;...
    0 0 0 0 0 1 0 0 0 0;...
    0 0 0 0 0 0 1 0 0 0;...
    0 0 0 0 0 0 0 1 0 0;...
    0 0 0 0 0 0 0 0 1 0;...
    0 0 0 0 0 0 0 0 0 1];

%% Initialization
Node_input = zeros(1,N_inputNode); % input node
Node_output = zeros(1,N_outputNode); % output node
weight = 2*rand(N_inputNode,N_outputNode)-1; % weight for each nodes. row for input, column for output
%weight = [0.5;0.5];
%threshold = rand(1,N_outputNode); % threshold of every links
threshold = 100*ones(1,10);
Weight_History = [];
%% Training Session
isLearned = false;
N_iteration = 0;
while ~isLearned 
    flag_Correct = false(size(TrainingSet_input,1),1);
    for s = 1 : size(TrainingSet_input,1) % s for set
        Node_input = TrainingSet_input(s,:);
        Node_output = Node_input * weight;
        Node_output = double(Node_output > threshold);
        weight = weight + LearningRate .* bsxfun(@times,Node_input',(TrainingSet_output(s,:)-Node_output));
        flag_Correct(s) = all(Node_output == TrainingSet_output(s,:));
        Weight_History(4*N_iteration + s,:,:) = weight;
    end
    N_iteration = N_iteration + 1;
    if all(flag_Correct)
        isLearned = true;
    end
    if rem(N_iteration ,50) == 0
        clc;
        fprintf('N_iteration = %d ...\n',N_iteration);
    end
end
%% Test Session
for s = 1 : size(TrainingSet_input,1)
    Node_input = TrainingSet_input(s,:);
    Node_output = Node_input * weight;
    Node_output = double(Node_output > threshold);
    fprintf(strcat('Input : ',repmat(' %d |',1,N_inputNode-1),' %d',' --> Output : ',repmat(' %d |',1,N_outputNode-1),' %d',' ==== Result : ',repmat(' %d |',1,N_outputNode-1),' %d \n'),...
        TrainingSet_input(s,1:N_inputNode), TrainingSet_output(s,1:N_outputNode),Node_output);
end
fprintf('----------------------------------------------------\n');
for I = 1 : N_inputNode
    for O = 1 : N_outputNode
        fprintf('Weight of (%d , %d) = %d\n',I,O,weight(I,O));
    end
end
fprintf('----------------------------------------------------\n');
fprintf('Completed in %d iterations\n',N_iteration);
%% 안되는 경우
%plot(Weight_History(1:100,1:2,1));
toc