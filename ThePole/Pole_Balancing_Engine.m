%% Pole_Balancing
%   Jeong Ji Hoon
%   ST_ID : 2016010980

%% JEONG_JIHOON
%   @Knowblesse
%   Created on 2016-12-01
%   Last Modified on 2016-12-01

%% Initialization
%clear; % close workspace
%clear;
%clc; % close command window (output window of Matlab)

%% Constants

Start_Pole_Angle = (1/2*pi) * rand(1) - (1/4*pi);  % 시작할 때  Pole의 중앙선으로부터의 각도. in rad
Start_Cart_Position = 10*rand(1)-5; % 시작할 때 Cart의 중앙선으로부터의 위치. in m

Mass_Cart = 1; % Cart의 질량 in kg
Mass_Pole = 100; % Pole의 질량 in kg. Assume the Density of the pole is uniform.

L = 6;  % Length of the Pole in m

%% Fixed
Length_Cart = 5; % in m. Lenght and Height of the cart doesn't affect the result.
Height_Cart = 1; % Only Location of the Center Point of the Cart matters.

Ts = 0.02; % Time Step in second
g = 9.81; % Gravity in m/s^2
Time_Limit = 10000; % in sec

%% Conditions
Track_Limit = 10; % in m
Pole_Failure_Angle = 12; % in rad

%% Variables
Cart = Start_Cart_Position; % Location of the Cart's Center Point
vCart = 0; % Velocity of the Cart m/s
aCart = 0; % Acceleration of the Cart m/s^2

Pole = Start_Pole_Angle; % Location of the Pole. rad
vPole = 0; % Velocity of the Pole. rad/s
aPole = 0; % Acceleration of the Pole. rad/s^2

F = 0; % Force Applied to the Cart. N

%% Initialize the Screen
figure(1);
clf;

% Draw Cart
rectangle('Position',[-Start_Cart_Position - (Length_Cart/2), -(Height_Cart/2), Length_Cart, Height_Cart],'FaceColor','k');

% Draw Pole
line([Cart, Cart + (L * sin(Start_Pole_Angle))],[0,L * cos(Start_Pole_Angle)],'Color','r', 'LineWidth',3);

axis([-10, 10, -1, 19]);

%% Run
for t = 1 : Time_Limit
    
    %% 이곳에 Pole, vPole, Cart, vCart 값들을 토대로 매 시간마다 F를 계산하는 부분을 넣습니다.
     % 예
     % F = mayTheForceBWithU(Pole,vPole,Cart,vCart);  
     % 
     % 이후 Pole이 쓰러졌는지 안쓰러졌는지의 여부에 따라 Value 값을 주는 방향으로 코딩을 하면 됩니다.
    
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
    
    % Draw Cart
    rectangle('Position',[Cart - (Length_Cart/2), -(Height_Cart/2), Length_Cart, Height_Cart],'FaceColor','k');

    % Draw Pole
    line([Cart, Cart + L * sin(Pole)],[0,L * cos(Pole)],'Color','r', 'LineWidth',3);
    axis([-10, 10, -1, 19]);

    drawnow;
    
    if ( Pole >= pi/2 || Pole <= -pi/2 ) % Fall on ground
        disp('Pole has fallen X_X');
        break;
    end
    if abs(Cart) > Track_Limit % Fall off the track
        disp('Cart has fallen X_X');
        break;
    end
    
    pause(Ts);
end
    