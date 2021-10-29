function volume = IbeamBridgeVolume(bridgeLength,width, treadLength,flangeThickness,webThickness, height)
%Volume of a bridge with given properties
%   bridgeLength: bridge length in inches
%   width: individual tread width in inches
%   flangeThickness: I beam flange thickness in inches
%   webThickness: I beam web thickness in inches
%   height: I beam height in inches
N_treads = ceil(bridgeLength./width);
v_tread = treadLength.*(2.*width.*flangeThickness+webThickness.*(height-2.*flangeThickness));
volume = N_treads.*v_tread;
end

