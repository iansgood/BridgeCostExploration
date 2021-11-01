clear all; close all; clc;

% Material Parameters %

SS = struct('E',28,'yield', 75,'density', 0.29,'cost',2); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
AL = struct('E',10,'yield', 40,'density', 0.1,'cost',4.5); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
GFRP = struct('E',4,'yield',45,'density',0.065,'cost',7); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]
TI = struct('E',16.5,'yield',125, 'density',0.16,'cost',103.04); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb]  (Ti6-Al4-V retrieved from Matweb.com, price from McMasterCarr Bar Stock)
% Titanium properties: Titanium Ti-6Al-4V (Grade 5), Annealed Bar from Matweb
% Titanium price: https://www.mcmaster.com/9081K49/
MPatomsi = 145/10^6; % Converts megapascals to mega-pounds per square inch
MPatoksi = 0.145; % Converts megapascals to killopounds per square inch
sgtolbpercubicinch = 0.03613; % converts specific gravity to pounds per cubic inch
ABS = struct('E',6900*MPatomsi,'yield',104*MPatoksi, 'density',1.29*sgtolbpercubicinch,'cost',4.38); % in [psi*10^6] [psi*10^3], [lb/in^3] , [$/lb] (ABS-GF30 retrieved from efunda, price from German Plastics marketplace pasticker.de)
% For ABS low values of E and yield strength are taken as conservative estimates.
% Yield strength is defined as compressive strength because the bridge will
% experience primarily compressive load.
% ABS properties: https://www.efunda.com/Materials/polymers/properties/polymer_datasheet.cfm?MajorID=ABS&MinorID=13
% ABS price: https://plasticker.de/recybase/showdata_en.php?id=324711&returnto=%2Frecybase%2Fpms2_en.php%3Fkat%3DMahlgut%26mat%3DABS%26aog%3DA

yield = [SS.yield AL.yield GFRP.yield TI.yield ABS.yield]; %in psi*10^3% 
E = [SS.E AL.E GFRP.E TI.E ABS.E];% in psi*10^6 
density = [SS.density AL.density GFRP.density TI.density ABS.density]; % in lb/in^3 
cost = [SS.cost AL.cost GFRP.cost TI.cost ABS.cost]; % in $/lb 

% Bridge Parameters %

bridge_span = 60*12; % in inches
tread_length = 25; % in inches
tread_load_per_width = 500; % in lbs/inch width
max_pounds_per_inch_no_penalty = 2; % lb/in
penalty = 0.50; % in dollars/lb
max_deflection = 0.75; %in inches

% Bridge Cross-Sectional Inputs and Parameters %


% See explanation on the above variable in the write up. Assuming that the
% grooves are symmetrical, the only parameter that matters is the length of
% the rectangle that is ungrooved/the material that remains. 

% Solve for Parameters %

% The following are design parameters groove depth ratio and total
% ungrooved section width

% Following values used for optimization plots
groove_depth_ratio = 0:0.05:0.75; % ratio of groove dept to total thickness
groove_width = 2:4/30:4; % total length of the ungrooved section in inches

% Values below can be used instead of above to look at specific case
%groove_depth_ratio = 1/2; % ratio of groove dept to total thickness
%groove_width = 2.25; % total length of the ungrooved section in inches

% The following vectors are used to create a study on the affect of the
% ungrooved length on the thickness, weight and cost

ss_volume = zeros(length(groove_width),length(groove_depth_ratio));
ss_weight = zeros(length(groove_width),length(groove_depth_ratio));
ss_cost = zeros(length(groove_width),length(groove_depth_ratio));

for iii = 1:length(groove_depth_ratio)
    for ii = 1: length(groove_width)
        width = 4; % in inches
        thickness_vector = zeros(5,1); % SS, Al, GFRP, Ti, ABS
        area_vector = zeros(5,1); % SS, Al, GFRP, Ti, ABS
        volume_vector = zeros(5,1); % SS, Al, GFRP, Ti, ABS
        weight_vector = zeros(5,1); % SS, Al, GFRP, Ti, ABS
        cost_vector = zeros(5,2);  % SS, Al, GFRP, Ti, ABS. Two columns for cost 
        % per tread and total bridge cost
        
        for i = 1:5
            thickness_vector(i,1) = thickness_solver(groove_depth_ratio(iii),width,tread_load_per_width,E(i),tread_length,yield(i),max_deflection,groove_width(ii));
            area_vector(i,1) = getArea(thickness_vector(i,1),width,groove_width(ii),groove_depth_ratio(iii));
            volume_vector(i,1) = area_vector(i,1)*tread_length;
            weight_vector(i,1) = getWeight(area_vector(i,1),tread_length,density(i));
            cost_vector(i,1:2) = getCost(weight_vector(i),cost(i),penalty,width,bridge_span);
            % Case study mentioned above for stainless steek=l
            if i == 1
                ss_volume(ii,iii) = volume_vector(i,1);
                ss_weight(ii,iii) = weight_vector(i,1);
                ss_cost(ii,iii) = cost_vector(i,1);
    
            end
        end
    end
end

all_parameters = [volume_vector,weight_vector,cost_vector];

%% Codes used for plotting

[X,Y] = meshgrid(groove_width,groove_depth_ratio);
Z = ss_volume';
figure(1)
surf(groove_width,groove_depth_ratio,Z)
xlabel('Total Un-grooved Width (in)')
ylabel('Groove Depth Ratio')
zlabel('Volume (in^3)')


figure(2)
Z = ss_weight';
surf(groove_width,groove_depth_ratio,Z)
xlabel('Total Un-grooved Width')
ylabel('Groove Depth Ratio')
zlabel('Weight (lbs)')

figure(3)
Z = ss_cost';
surf(groove_width,groove_depth_ratio,Z)
xlabel('Total Un-grooved Width')
ylabel('Groove Depth Ratio')
zlabel('Cost ($)')

