% BOUNDEDAREA Returns the bounded signed area of general polygon
%   A = boundedArea(g) calculates the bounded signed area of the general
%   polygon g using Green's theorem (trapezoid formula). The size of g is
%   2xn, where each column contains the Cartesian coordinates of a vertex.
%
%   If g is orientable, then g is positively oriented iff A>0
%   If g is orientable, then g is negatively oriented iff A<0
%   If g is orientable, then g is null oriented iff A=0
%   A>0 does not imply that g is positively oriented
%   A<0 does not imply that g is negatively oriented
%   A=0 does not imply that g is null oriented
function A = boundedArea(g)
x = g(1,:);y = g(2,:);
A = .5*sum((x-x([2:end 1])).*(y+y([2:end 1])));
end
