%PA2XYZ Spherical coordinates to Cartesian Coordinates
%   XYZ = ap2xyz(PA) accepts PA as an 2xn matrix, where each column
%   contains the polar angle and the azimuthal angle of a point in
%   radians. It returns XYZ as an 3xn matrix, where each column contains
%   the Cartesian coordinates of the points on the unit sphere
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function xyz = pa2xyz(pa)
xyz = zeros(3,size(pa,2));
xyz(1,:) = cos(pa(2,:)).*sin(pa(1,:));
xyz(2,:) = sin(pa(2,:)).*sin(pa(1,:));
xyz(3,:) = cos(pa(1,:));
