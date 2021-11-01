function [price, massBeam] = bridgeCost(tr,density,t,cost)
%{
 bridgeCost calculates the cost of a bridge made from a material and of a
 specified length
 INPUTS
    tr is the bridge struct
    density is a vector of material densities
    t is a vector of beam thicknesses
    cost is a vector of the bulk material cost
  OUTPUTS
  price is the cost to build a bridge from the material
%}
cost = cost + 0.2*ones(1,length(cost)); % add the additional cost to produce
if tr.width == 3
    massBeam = density.*31.938091.*t; %in lbs. Area taken from Solidworks Model    
elseif tr.width == 4
    massBeam = density.*39.119370.*t; %in lbs. Area taken from Solidworks Model
elseif tr.width == 6
    massBeam = density.*57.920116.*t; %in lbs. Area taken from Solidworks Model
else
    e = error(1,'not supported width, try 3, 4, or 6in');
end    

numTreads = ceil(tr.bridgeLength ./ tr.width);
costMatl = massBeam.*cost.*numTreads;
%if there is a better way to do this, please implement it
for iter = 1:length(massBeam)
    if massBeam(iter) - tr.costLength .* tr.width > 0 %check if the mass of the beam exceeds 2lbs/(in width)
        costPenalty(iter)  = numTreads.*(massBeam(iter) -tr.costLength.*tr.width).*0.5;
    else
        costPenalty(iter)  = 0;
    end
end

price = costMatl +costPenalty;



end

