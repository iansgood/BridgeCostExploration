function [cost_vector] = getCost(weight,cost,penalty,width,span)
%Calculating the cost using the weight and the cost per weight, while
%assessing a penalty for weight greater than 2lbs/in

cost_before_penalty = weight*cost;

if weight-2*width > 0
    penalty = (weight-2*width)*penalty;
else
    penalty = 0;
end

cost_per_tread = cost_before_penalty+penalty;

treads_per_bridge = span/width;

total_cost = cost_per_tread*treads_per_bridge;

cost_vector = [cost_per_tread,total_cost];
end