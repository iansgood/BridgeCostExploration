function [h_Str,h_Def] = height(deflection,P,L,b,yeild,E)
%{
 HEIGHT calculates the minimum safe thickness for a beam using yeilding and deflection
 INPUTS
    deflection is the maximum allowed deflection for a fixed beam. [m]
    P is the point load [N]
    L is the beam length [m]
    yeild is the yeild strength [MPa]
    b is the beam width [m]
    E is the Modulus of Elasticty [MPa]
  OUTPUTS
  h_Str is the height required for yeilding to not take place
  h_def is the height required for the deflection criteria to be met
%}
h_Str = sqrt(8.* P.*L ./ b.*yeild/1E6); %in m
h_Def = (P.*L.^3./(4*b.*E/1E6.*deflection)).^1/3; %in m
end

