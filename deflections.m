function [deflection_table] = deflections(forcePerWidth, widths, lengths, E, Ix)
% Calculates deflection given various geometric parameters
%   forcePerWidth -> Force in pounds per inch pressing down on the beam
%   width -> width of beam in inches
%   length -> length of beam in inches
%   E -> Young's Modulus in psi*10^6
%   Ix -> Minimal moment of inertia of the beam along the x axis in in^4
%   Assumes that width, length and Ix are the same length. Will cause an
%   error otherwise.
beams = length(widths);
materials = length(E);
deflection_table = zeros(beams,materials);
for beam = 1:beams
    for material = 1:materials
        width = widths(beam);
        length_beam = lengths(beam);
        youngsModulus = E(material).*10.^6; %convert to pounds
        momentInertia = Ix(beam);
        deflection_table(beam, material) = (forcePerWidth.*width.*length_beam.^3)./(48.*youngsModulus.*momentInertia);
    end
end
end