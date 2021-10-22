clear all; close all; clc;
%% Input Variables %%

% Material Parameters %
SS = struct('E',193053.20384,'yeild',517.1068, 'density',8027.17237,'cost',4.40925); % in [MPa] [Mpa], [kg/m^3] , [$/kg]
AL = struct('E',68947.5728,'yeild',275.7902912, 'density',2767.99047,'cost',9.9208); % in [MPa] [Mpa], [kg/m^3] , [$/kg]
GFRP = struct('E',27579.02912,'yeild',310.2640776, 'density',1799.19381,'cost',15.4324); % in [MPa] [Mpa], [kg/m^3] , [$/kg]
TI = struct('E',114000,'yeild',830, 'density',4428.78475,'cost',103.04); % in [MPa] [Mpa], [kg/m^3] , [$/kg]  (Ti6-Al4-V retrieved from Matweb.com, price from McMasterCarr Bar Stock)
ABS = struct('E',8200,'yeild',110, 'density',1240,'cost',9.65); % in [MPa] [Mpa], [kg/m^3] , [$/kg] (ABS-GF30 retrieved from efunda, price from German Plastics marketplace pasticker.de)
%after having made these as structs, I think it might make more sense to
%just use vectors for each of the different terms
yeild = [SS.yeild AL.yeild GFRP.yeild TI.yeild ABS.yeild];
E = [SS.E AL.E GFRP.E TI.E ABS.E];



% Bridge Parameters %
tr = struct('length_cost',0.762,'length_eng',0.635,'width',0.101599,'deflectionMax',0.01905,'loadDist',0.3175,'bridgeLength',18.288,'loadMax',8928.97); %in [m], [m], [m], [m], [m], [m], and [kg/m] 30in , 25in, 4in, 0.75in, 12.5in, 60ft, 500lb/in 

%cost note: don't forget to account for the additional cost of $0.50 / lb
%over 2lbs/in 


% Derived Parameters
thickness = thickness(tr,yeild,E) % I believe there is an error in my calculations for this


%%

% write a function that takes in Moment of Inertia, and Bending Moment


