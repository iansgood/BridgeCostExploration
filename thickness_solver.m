function [thickness_necessary] = thickness_solver(x,w,P,E,L,S,d,gw)

% This function takes the inputs of groove depth ratio x, tread width w (either 3
% or 4 inches), load (load per width), Young's modulus E, tread length L,
% yield strength S, max deflection d, and total groove width gw and then 
% backsolves to find necessary moment of inertia, which will then be used 
% to find necessary thickness. This is more complicated then a rectangular 
% beam cross section as the centroid will be a function of groove depth and
% width and then the max distance from centroid axis y used in the 
% equation My/I will also depend on h


max_d = d; % max deflection in inches
load = P*w; % total load in lbs
E = E*10^6;
S = S*10^3;

min_inertia_deflection = (load*L^3)/(48*E*max_d);

moment = load*L/4;

syms t positive
x = x*t;
centroid = (((t-x)/2*(t-x)*w)+(t-x/2)*(x*gw))/((t-x)*w+x*gw);
moment_of_inertia_base = (w*(t-x)^3)/12 + w*(t-x)*((t-x)/2-centroid)^2;
moment_of_inertia_grooves = (gw*x^3)/12 + x*gw*((t-x/2)-centroid)^2;
total_moment_of_inertia_eqn = moment_of_inertia_grooves + moment_of_inertia_base;

thickness_deflection = solve(total_moment_of_inertia_eqn == min_inertia_deflection,t,'Real',true);
thickness_stress = solve(S/moment == (t-centroid)/total_moment_of_inertia_eqn,t,'Real',true);

thickness_necessary = max([double(thickness_deflection),double(thickness_stress)]);


end