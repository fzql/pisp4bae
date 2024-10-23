%AP2XYZ Spherical coordinates to Cartesian Coordinates
%   XYZ = ap2xyz(AP) accepts a row vector of azimuthal angle and zenith
%   angle in radians, and returns a row vector of the X, Y, and Z
%   coordinates on the unit sphere.
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function xyz = ap2xyz(ap)
xyz = zeros(size(ap,1),3);
xyz(:,1) = cos(ap(:,1)).*sin(ap(:,2));
xyz(:,2) = sin(ap(:,1)).*sin(ap(:,2));
xyz(:,3) = cos(ap(:,2));
