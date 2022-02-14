%% Pole_Balancing_GeneticAlgorithm
%   Jeong Ji Hoon
%   ST_ID : 2016010980

%% JEONG_JIHOON
%   @Knowblesse
%   Created on 2016-12-08
%   Tested on MATLAB 2015a

%% Initialization
% clear; % close workspace
% clear;
% clc; % close command window (output window of Matlab)
tic
rng('Shuffle');

%% Constants

Mass_Cart = 1; % Cart의 질량 in kg
Mass_Pole = 0.1; % Pole의 질량 in kg. Assume the Density of the pole is uniform.

L = 6;  % Length of the Pole in m

%% Fixed
Length_Cart = 5; % in m. Lenght and Height of the cart doesn't affect the result.
Height_Cart = 1; % Only Location of the Center Point of the Cart matters.

Ts = 0.02; % Time Step in second
g = 9.81; % Gravity in m/s^2
Time_Limit = 500; % steps

%% Conditions
Track_Limit = 10; % in m
Pole_Failure_Angle = 12; % in rad
DisplayOn = true;

%% Gene
N_Generation = 100;

N_Gene = 100;
L_Gene = 4;
Gene = cell(1,N_Generation);
Gene{1} = 2*rand(L_Gene,N_Gene)-1;

Performance = cell(1,N_Generation);

%% Mating
N_Selection = 20;
P_Mutation = 0.1;

%% Logging
SelPerf = cell(1,N_Generation); % selected gene's performance;
SelGene = cell(1,N_Generation);

%% Learning
for generation = 1 : N_Generation
    for g = 1 : N_Gene
    
        Start_Pole_Angle = (1/2*pi) * rand(1) - (1/4*pi);  % 시작할 때  Pole의 중앙선으로부터의 각도. in rad
        Start_Cart_Position = 10*rand(1)-5; % 시작할 때 Cart의 중앙선으로부터의 위치. in m

        %% Variables
        Cart = Start_Cart_Position; % Location of the Cart's Center Point
        vCart = 0; % Velocity of the Cart m/s
        aCart = 0; % Acceleration of the Cart m/s^2

        Pole = Start_Pole_Angle; % Location of the Pole. rad
        vPole = 0; % Velocity of the Pole.rad/s
        aPole = 0; % Acceleration of the Pole. rad/s^2

        F = 0; % Force Applied to the Cart. N

        %% Run
        if rem(generation,10) == 10 && g ==1
           %% Initialize the Screen
            fig = figure(1);
            fig.Name = ['Generation ', num2str(generation), ' Gene ', num2str(g)];
            clf;

            % Draw Cart
            rectangle('Position',[-Start_Cart_Position - (Length_Cart/2), -(Height_Cart/2), Length_Cart, Height_Cart],'FaceColor','k');

            % Draw Pole
            line([Cart, Cart + (L * sin(Start_Pole_Angle))],[0,L * cos(Start_Pole_Angle)],'Color','r', 'LineWidth',3);

            axis([-10, 10, -1, 19]);
           %% Run        
            for t = 1 : Time_Limit
                F = [Pole, vPole, Cart, vCart] * Gene{generation}(:,g);

                new_aPole = (     g*sin(Pole) + cos(Pole)*(  (-F -Mass_Pole*L/2*vPole^2*sin(Pole))/(Mass_Cart + Mass_Pole)  )     )...
                    / ( L/2 * (4/3 - (Mass_Pole*(cos(Pole))^2) / (Mass_Cart + Mass_Pole) ));
                new_aCart = (F + Mass_Pole*L/2 * ( vPole^2*sin(Pole) - aPole*cos(Pole) )) / (Mass_Cart+Mass_Pole);

                aPole = new_aPole;
                aCart = new_aCart;

                vPole = vPole + Ts * aPole;
                vCart = vCart + Ts * aCart;

                Pole = Pole + Ts * vPole;
                Cart = Cart + Ts * vCart;

                clf;

                subplot(2,2,[1,3]);

                % Draw Cart
                rectangle('Position',[Cart - (Length_Cart/2), -(Height_Cart/2), Length_Cart, Height_Cart],'FaceColor','k');

                % Draw Pole
                line([Cart, Cart + L * sin(Pole)],[0,L * cos(Pole)],'Color','r', 'LineWidth',3);
                axis([-10, 10, -1, 19]);

                subplot(2,2,2);
                if F > 0
                    bar(F,'r');
                else
                    bar(F,'b');
                end
                axis([0,2,-10,10]);
                title('Force');
                ylabel('Force(N)');
                grp = gca;
                grp.XTickLabel = 'Force to Right';

                subplot(2,2,4);
                bar([Pole,vPole,Cart,vCart]);
                axis([0,5,-5,5]);
                title('Parameter');

                grp = gca;
                grp.XTickLabel = {'Pole', 'vPole', 'Cart', 'vCart'};

                drawnow;

                if ( Pole >= pi/2 || Pole <= -pi/2 ) % Fall on ground
                    disp('Pole has fallen X_X');
                    Performance{generation}(g) = t;
                    disp(t);
                    break;
                end
                if abs(Cart) > Track_Limit % Fall off the track
                    disp('Cart has fallen X_X');
                    Performance{generation}(g) = t;
                    disp(t);
                    break;
                end
                if t >= Time_Limit
                    disp('Success');
                    Performance{generation}(g) = Time_Limit;
                    disp(t);
                end
            end
        else
           %% Run w/o display
            for t = 1 : Time_Limit
                F = [Pole, vPole, Cart, vCart] * Gene{generation}(:,g);

                new_aPole = (     g*sin(Pole) + cos(Pole)*(  (-F -Mass_Pole*L/2*vPole^2*sin(Pole))/(Mass_Cart + Mass_Pole)  )     )...
                    / ( L/2 * (4/3 - (Mass_Pole*(cos(Pole))^2) / (Mass_Cart + Mass_Pole) ));
                new_aCart = (F + Mass_Pole*L/2 * ( vPole^2*sin(Pole) - aPole*cos(Pole) )) / (Mass_Cart+Mass_Pole);

                aPole = new_aPole;
                aCart = new_aCart;

                vPole = vPole + Ts * aPole;
                vCart = vCart + Ts * aCart;

                Pole = Pole + Ts * vPole;
                Cart = Cart + Ts * vCart;

                if ( Pole >= pi/2 || Pole <= -pi/2 ) % Fall on ground
                    Performance{generation}(g) = t;
                    break;
                end
                if abs(Cart) > Track_Limit % Fall off the track
                    Performance{generation}(g) = t;
                    break;
                end
                if t >= Time_Limit
                    Performance{generation}(g) = Time_Limit;
                end
            end
        end
    end
    %% Natural Selection
    [SelPerf{generation},iSelGene] = sortsel(Performance{generation},N_Selection,'descend');
    SelGene{generation} = Gene{generation}(:,iSelGene);
    %% Mating
    for g = 1 : N_Gene
        % Select Parents
        num = randi(N_Selection);
        Father = SelGene{generation}(:,num);
        tempGene = SelGene{generation};
        tempGene(:,num) = [];
        Mother = tempGene(:,randi(N_Selection-1));
        Parents = [Father,Mother];
        % Mate
        for allele = 1 : 4
            num = randi(2);
            Gene{generation+1}(allele,g) = normrnd(Parents(allele,num),0.1 * abs(Parents(allele,num)));
        end
        % Mutation
        if rand(1) < P_Mutation
            point = randi(4);
            Gene{generation+1}(point,g) = normrnd(Gene{generation+1}(point,g), 2 * abs(Gene{generation+1}(point,g)));
        end
    end
end

figure(2);
clf;
meanPerf = zeros(N_Generation,1);
maxPerf = zeros(N_Generation,1);
for i = 1 : N_Generation
    meanPerf(i) = mean(Performance{i});
    maxPerf(i) = max(Performance{i});
end
plot(meanPerf);
figure(3);
plot(maxPerf);
toc