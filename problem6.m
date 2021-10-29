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
w6x15 = struct('length',25,'width',5.99,'height',5.99,'Ix',29.1, 'FlangeThickness', 0.26, 'WebThickness', 0.23); %in, in, in, in^4, in, in.
w6x12 = struct('length',25,'width',4,'height',6.03,'Ix',22.1, 'FlangeThickness', 0.28, 'WebThickness', 0.23); %in, in, in, in^4, in, in.
w6x9 = struct('length',25,'width',3.94,'height',5.9,'Ix',16.4, 'FlangeThickness', 0.215, 'WebThickness', 0.17); %in, in, in, in^4, in, in.
w5x19 = struct('length',25,'width',5.03,'height',5.15,'Ix',26.2, 'FlangeThickness', 0.43, 'WebThickness', 0.27); %in, in, in, in^4, in, in.
w5x16 = struct('length',25,'width',5,'height',5.01,'Ix',21.3, 'FlangeThickness', 0.36, 'WebThickness', 0.24); %in, in, in, in^4, in, in.
w4x13 = struct('length',25,'width',4.06,'height',4.16,'Ix',11.3, 'FlangeThickness', 0.345, 'WebThickness', 0.28); %in, in, in, in^4, in, in.

lengths = [w6x15.length, w6x12.length, w6x9.length, w5x19.length, w5x16.length, w4x13.length];
widths = [w6x15.width, w6x12.width, w6x9.width, w5x19.width, w5x16.width, w4x13.width];
heights = [w6x15.height, w6x12.height, w6x9.height, w5x19.height, w5x16.height, w4x13.height];
Ix = [w6x15.Ix, w6x12.Ix, w6x9.Ix, w5x19.Ix, w5x16.Ix, w4x13.Ix];
flangeThickness = [w6x15.FlangeThickness, w6x12.FlangeThickness, w6x9.FlangeThickness, w5x19.FlangeThickness, w5x16.FlangeThickness, w4x13.FlangeThickness];
webThickness = [w6x15.WebThickness, w6x12.WebThickness, w6x9.WebThickness, w5x19.WebThickness, w5x16.WebThickness, w4x13.WebThickness];

bridgeLength = 60; % ft
inchesPerFoot = 12;
bridgeLength = bridgeLength.*inchesPerFoot;
% Other Paramters %
forcePerWidth = 500; % lb/in
maxPoundsPerInchNoPenalty = 2; % lb/in

% Solve for deflections
deflection_table = deflections(forcePerWidth, widths, lengths, E, Ix);

% Solve for stresses
stress_table = stress(forcePerWidth, widths, lengths, heights, Ix);

% Solve for volume
volume = IbeamBridgeVolume(bridgeLength,widths, lengths,flangeThickness,webThickness, heights);
volumeW6x9 = volume(3);
massW6x9 = volumeW6x9.*density;

penaltyThreshold = maxPoundsPerInchNoPenalty.*bridgeLength; % pounds
penalty = 0.5; % $/lb

bridgeCost = cost.*massW6x9+max(0,massW6x9-penaltyThreshold).*penalty;