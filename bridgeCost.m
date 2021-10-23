function [price] = bridgeCost(tr,density,t,cost)
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
massBeam = density.*tr.width.*tr.length.*t;
%massBeam(2) = 6.8*0.4536; % checking for rounding error by manually inserting Ram's weight
% This reduced the error to $30.69
numTreads = ceil(tr.bridgeLength ./ tr.width);
costMatl = massBeam.*cost.*numTreads;
penaltyThreshold = 2; % lb/in
%if there is a better way to do this, please implement it
for iter = 1:length(massBeam)
    if massBeam(iter) - tr.costLength .* tr.width > 0 %check if the mass of the beam exceeds 2lbs/(in width)
        costPenalty(iter)  = numTreads.*(massBeam(iter) -penaltyThreshold.*tr.width).*0.5;
    else
        costPenalty(iter)  = 0;
    end
end

price = costMatl +costPenalty;



end

