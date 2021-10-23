function [hStr,hDef] = thickness(tr,yeild,E)
%{
 thickness calculates the minimum safe thickness for a beam using yeilding and deflection
 INPUTS
    tr is the bridge struct
    yeild is the yeild strength of all materials in vector form
    E is the modulus of elasticity of all materials in vector form
  OUTPUTS
  h_Str is the height required for yeilding to not take place
  h_def is the height required for the deflection criteria to be met
%}

p = tr.width.*tr.loadMax; % in lb

hStr = sqrt(   (3.*p.*tr.length) ./ (2.*tr.width.*yeild.*1000)  ); % in
% sqrt((lb * in)/(in*(klb/in^2))) = in upon converting yield to lb
hDef = nthroot(     (p.*tr.length.^3) ./ (4.*E.*10.^6.*tr.width.*tr.deflectionMax)     ,3); %in m
% cube root((lb*in^3/(4*in*in*Mlb/in^2)) = cube root((lb*in/(4*Mlb/in^2)) =
% inch upon converting E to lb


end

