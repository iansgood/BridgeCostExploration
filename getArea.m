function [area] = getArea(t,w,gw,x)

% This functions gets the area of the grooved section used in problem 4 using thickness,
% width, ungrooved width and groove depth ratio x

groove_area = gw*x*t;
base_area = (t-x*t)*w;
area = groove_area+base_area;

end
