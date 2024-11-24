%PISP Point-in-spherical-polygon algorithm using Q-north rotation
%   [S,g1,g2] = pisp([a;b;c],G) determines if the given test point
%   Q(a,b,c) lies in the interior of, on the boundary of, or to the
%   exterior of a general spherical polygon G. The size of G is 3xn,
%   where each column contains the Cartesian coordinates of a vertex
%
%   The unit sphere must be centered at the origin
%
%   Value of S: 1 (interior), 0 (boundary), -1 (exterior).
%   Debugging only: g1, g2
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function [S,g1,g2] = pisp(Q,G)
S = nan;
g1 = zeros(2,size(G,2));
g2 = zeros(2,size(G,2));
end
