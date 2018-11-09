%%
clear;
clc;
trials = [] ;% CS1 | CS2 | US // 0 for +, 1 for -

V_CS1 = 0;
V_CS2 = 0;

dV_CS1 = 0;
dV_CS2 = 0;

CS1_saliency = 1;
CS2_saliency = 0.2;
US_saliency = 1;

learningRate_aq = 0.1; 
learningRate_ex = 0.05;
%%
% trials = zeros(40,3);
% trials(1:20,1) = 1; % CS ON
% trials(11:20,3) = 1; % US ON
% trials = repmat(trials,20,1);
trials = zeros(3,3);
trials(1,1) = 1; % CS ON
trials(1,3) = 1;
trials(2,2) = 1;
trials(2,3) = 1;
trials(3,1) = 1;
trials(3,2) = 1;
trials = repmat(trials,500,1);
% for i = 1 : 100
%     trials(i,1) = 1;
%     trials(i,2) = 0;
%     trials(i,3) = 0;
% end
% for i = 101 : 200
%     trials(i,1) = 1;
%     trials(i,2) = 0;
%     trials(i,3) = 1;
% end
% for i = 101 : 125
%     trials(i,1) = 1;
%     trials(i,2) = 1;
%     trials(i,3) = 0;
% end
% for i = 201 : 300
%     trials(i,1) = 0;
%     trials(i,2) = 0;
%     trials(i,3) = 0;
% end
% for i = 301 : 310
%     trials(i,1) = 1;
%     trials(i,2) = 1;
%     trials(i,3) = 0;
% end
%% 
save('Quiz.mat');
%%
figure;
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
title('US');
