%% Rescorla Wagner Model
%   @knowblesse
%   Created on : 2016-09-28
%   Last Modified on : 2016-09-28
%% Initialize
clc;
clear;
close;
%% Experimental Conditions
trials = [] ;% CS1 | CS2 | US // 0 for +, 1 for -
learningRate_aq = 0.1; 
learningRate_ex = 0.05;
%% Variables for RW
V_CS1 = 0;
V_CS2 = 0;
dV_CS1 = 0;% delta V
dV_CS2 = 0;% delta V
CS1_saliency = 0;
CS2_saliency = 0;
US_saliency = 0;
%% load Experimental Conditions
filename = uigetfile('.mat');
load(filename);
%% Simulate RW
for i = 1 : size(trials);
    if trials(i,3) == 1 % US exist
        dV_CS1 = CS1_saliency * learningRate_aq * (US_saliency - (V_CS1(end)*trials(i,1) + V_CS2(end)*trials(i,2)));
        dV_CS2 = CS2_saliency * learningRate_aq * (US_saliency - (V_CS1(end)*trials(i,1) + V_CS2(end)*trials(i,2)));
        dV_CS1 = dV_CS1 * trials(i,1); % zero when CS doesn't exist
        dV_CS2 = dV_CS2 * trials(i,2); % zero when CS doesn't exist
        V_CS1 = [V_CS1, V_CS1(end) + dV_CS1];
        V_CS2 = [V_CS2, V_CS2(end) + dV_CS2];
    else % US doesn't exist
        dV_CS1 = CS1_saliency * learningRate_ex * (- (V_CS1(end)*trials(i,1) + V_CS2(end)*trials(i,2)));
        dV_CS2 = CS2_saliency * learningRate_ex * (- (V_CS1(end)*trials(i,1) + V_CS2(end)*trials(i,2)));
        dV_CS1 = dV_CS1 * trials(i,1); % zero when CS doesn't exist
        dV_CS2 = dV_CS2 * trials(i,2); % zero when CS doesn't exist
        V_CS1 = [V_CS1, V_CS1(end) + dV_CS1];
        V_CS2 = [V_CS2, V_CS2(end) + dV_CS2];
    end
end
%% Plot V_CS1 V_CS2
figure(1);
clf;
plot(V_CS1);
hold on;
plot(V_CS2);
legend 'V CS1' 'V CS2';