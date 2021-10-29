function stress_table = stress(forcePerWidth, widths, lengths, hieghts, Ix)
% Calculates stress on the beam given a force and beam properties.
%   forcePerWidth -> Force in pounds per inch pressing down on the beam
%   widths -> width of beam in inches
%   lengths -> length of beam in inches
%   hieghts -> height of beam in inches
%   Ix -> Minimal moment of inertia of the beam along the x axis in in^4
%   Assumes that width, length and Ix are the same length. Will cause an
%   error otherwise.
beams = length(widths);
stress_table = zeros(beams,1);
for beam = 1:beams
    width = widths(beam);
    length_beam = lengths(beam);
    height = hieghts(beam);
    momentInertia = Ix(beam);
    stress_table(beam) = (forcePerWidth.*width.*length_beam.*height)./(8.*momentInertia);
end
end

