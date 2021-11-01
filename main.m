clear all; close all; clc;
%% Input Variables %%

% Material Parameters %
SS = struct('E',28,'yeild', 75,'density', 0.29,'cost',2); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
AL = struct('E',10,'yeild', 40,'density', 0.1,'cost',4.5); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
GFRP = struct('E',4,'yeild',45,'density',0.065,'cost',7); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
TI = struct('E',16.5,'yeild',125, 'density',0.16,'cost',103.04); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]  (Ti6-Al4-V retrieved from Matweb.com, price from McMasterCarr Bar Stock)
% Titanium properties: Titanium Ti-6Al-4V (Grade 5), Annealed Bar from Matweb
% Titanium price: https://www.mcmaster.com/9081K49/
MPatomsi = 145/10^6; % Converts megapascals to mega-pounds per square inch
MPatoksi = 0.145; % Converts megapascals to killopounds per square inch
sgtolbpercubicinch = 0.03613; % converts specific gravity to pounds per cubic inch
ABS = struct('E',6900*MPatomsi,'yeild',104*MPatoksi, 'density',1.29*sgtolbpercubicinch,'cost',4.38); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb] (ABS-GF30 retrieved from efunda, price from German Plastics marketplace pasticker.de)
% For ABS low values of E and yield strength are taken as conservative estimates.
% Yield strength is defined as compressive strength because the bridge will
% experience primarily compressive load.
% ABS properties: https://www.efunda.com/Materials/polymers/properties/polymer_datasheet.cfm?MajorID=ABS&MinorID=13
% ABS price: https://plasticker.de/recybase/showdata_en.php?id=324711&returnto=%2Frecybase%2Fpms2_en.php%3Fkat%3DMahlgut%26mat%3DABS%26aog%3DA
yeild = [SS.yeild AL.yeild GFRP.yeild TI.yeild ABS.yeild]; %in psi*10^3% 
E = [SS.E AL.E GFRP.E TI.E ABS.E];% in psi*10^6 
density = [SS.density AL.density GFRP.density TI.density ABS.density]; % in lb/in^3 
cost = [SS.cost AL.cost GFRP.cost TI.cost ABS.cost]; % in $/lb 

% Bridge Parameters %
fttoinch = 12; % inches per foot
tr3 = struct('length',25,'width',3,'deflectionMax',0.75,'loadDist',12.5,'bridgeLength',60*fttoinch,'loadMax',500,'costLength',2); %in in, in, in, in, in, lb/in, and lb/in. 
tr4 = struct('length',25,'width',4,'deflectionMax',0.75,'loadDist',12.5,'bridgeLength',60*fttoinch,'loadMax',500,'costLength',2); %in in, in, in, in, in, lb/in, and lb/in. 
tr6 = struct('length',25,'width',6,'deflectionMax',0.75,'loadDist',12.5,'bridgeLength',60*fttoinch,'loadMax',500,'costLength',2); %in in, in, in, in, in, lb/in, and lb/in. 

%cost note: don't forget to account for the additional cost of $0.50 / lb
%over 2lbs/in 


% Solve for Thickness
[tYeild3 tDef3] = thickness(tr3,yeild,E);
t3 = max(tYeild3,tDef3);

[tYeild4 tDef4] = thickness(tr4,yeild,E);
t4 = max(tYeild4,tDef4);

[tYeild6 tDef6] = thickness(tr6,yeild,E);
t6 = max(tYeild6,tDef6);
% circular cutouts
[tYeild3C tDef3C] = thicknessCircle(tr3,yeild,E);
t3C = max(tYeild3C,tDef3C);
[tYeild4C tDef4C] = thicknessCircle(tr4,yeild,E);
t4C = max(tYeild4C,tDef4C);



%% Total Project Cost Function
price3 = round(bridgeCost(tr3,density,t3,cost),2); %in USD
price4 = round(bridgeCost(tr4,density,t4,cost),2); %in USD
price6 = round(bridgeCost(tr6,density,t6,cost),2); %in USD

%Circular cutouts
price3C = round(bridgeCostCircle(tr3,density,t3C,cost),2); %in USD
price4C = round(bridgeCostCircle(tr4,density,t4C,cost),2); %in USD









