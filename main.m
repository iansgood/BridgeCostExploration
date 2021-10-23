clear all; close all; clc;
%% Input Variables %%

% Material Parameters %
SS = struct('E',28,'yeild', 75,'density', 0.29,'cost',2); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
AL = struct('E',10,'yeild', 40,'density', 0.1,'cost',4.5); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
GFRP = struct('E',4,'yeild',45,'density',0.065,'cost',7); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
%TI = struct('E',114000,'yeild',830, 'density',4428.78475,'cost',103.04); % in [MPa] [Mpa], [kg/m^3] , [$/kg]  (Ti6-Al4-V retrieved from Matweb.com, price from McMasterCarr Bar Stock)
%ABS = struct('E',8200,'yeild',110, 'density',1240,'cost',9.65); % in [MPa] [Mpa], [kg/m^3] , [$/kg] (ABS-GF30 retrieved from efunda, price from German Plastics marketplace pasticker.de)
%after having made these as structs, I think it might make more sense to
%just use vectors for each of the different terms
yeild = [SS.yeild AL.yeild GFRP.yeild]; %in psi*10^3% TI.yeild ABS.yeild]; %in MPa
E = [SS.E AL.E GFRP.E];% in psi*10^6 TI.E ABS.E]; %in MPa
density = [SS.density AL.density GFRP.density]; % in lb/in^3 TI.density ABS.density];
cost = [SS.cost AL.cost GFRP.cost]; % in $/lb TI.cost ABS.cost]; % in $/kg

% Bridge Parameters %
fttoinch = 12; % inches per foot
tr = struct('length',25,'width',4,'deflectionMax',0.75,'loadDist',12.5,'bridgeLength',60*fttoinch,'loadMax',500,'costLength',2); %in in, in, in, in, in, lb/in, and lb/in. 

%cost note: don't forget to account for the additional cost of $0.50 / lb
%over 2lbs/in 


% Solve for Thickness
[tYeild tDef] = thickness(tr,yeild,E); % I believe there is an error in my Yeild calculations in this function
t = max(tYeild,tDef);

tGroundTruth = [0.5 0.68 0.87]; %in in
tError = abs(tGroundTruth.^2 - t(1:3).^2); %L2 Norm of the difference


%% Total Project Cost Function

price = round(bridgeCost(tr,density,t,cost),2); %in USD
BridgeAlPrice = 5508; 
errorCost = abs(price(2) - BridgeAlPrice);
disp(errorCost) % this difference is fully accounted for by the key rounding
% the height. 5508-4.5*0.1*4*25*sqrt(18.75/40)*0.25*12*60 = 37.69
% (approximately)






