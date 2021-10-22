function [hStr,hDef] = thickness(tr,yeild,E)
%{
 HEIGHT calculates the minimum safe thickness for a beam using yeilding and deflection
 INPUTS
    tr is the bridge struct
    yeild is the yeild strength of all materials in vector form
    E is the modulus of elasticity of all materials in vector form
  OUTPUTS
  h_Str is the height required for yeilding to not take place
  h_def is the height required for the deflection criteria to be met
%}

p = tr.width.*tr.loadMax; %error is here, should be 9k N

hStr = sqrt(   (3*p.*tr.length) ./ (2*tr.width.*yeild)  ) /1000; %in m
hDef = nthroot(     (p.*tr.length.^3) ./ (4.*E/1E3.*tr.width.*tr.deflectionMax)     ,3) /1000; %in m




end

