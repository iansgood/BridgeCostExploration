function [price] = bridgeCost(tr,density,t,cost)
%{
 thickness calculates the cost of a bridge made from a material and of a
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
numTreads = ceil(tr.bridgeLength ./ tr.width);
costMatl = massBeam.*cost.*numTreads;

%if there is a better way to do this, please implement it
for iter = 1:length(massBeam)
    if massBeam(iter) - tr.costLength .* tr.width > 0 %check if the mass of the beam exceeds 2lbs/(in width) in metric
        costPenalty(iter)  = numTreads.*(massBeam(iter) -0.907185.*tr.width).*0.5;
    else
        costPenalty(iter)  = 0;
    end
end

price = costMatl +costPenalty;



end

