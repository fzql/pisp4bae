% BOUNDEDAREA Returns the bounded signed area of general polygon
%   A = boundedArea(g,dtheta) calculates the bounded signed area of the projected
%   polygon with vertices g using Green's theorem. The size of g is
%   2xn, where each column contains the Cartesian coordinates of a vertex.
%
%   Note: The sign of A cannot be used to infer the orientation of G, the
%   spherical polygon whose stereographic projection is g, without knowing
%   beforehand that G is orientable on S^2.
function A = boundedArea(G)
    CA = cross(cross(G,G(:,[2:end 1])),G);
    CA = CA./vecnorm(CA);
    CB = cross(cross(G(:,[2:end 1]),G),G(:,[2:end 1]));
    CB = CB./vecnorm(CB);
    tA = CA(1:2,:).*(1-G(3,:))+G(1:2,:).*CA(3,:);
    tB = -(CB(1:2,:).*(1-G(3,[2:end 1]))+G(1:2,[2:end 1]).*CB(3,:));
    dtheta = atan2((tA(1,:).*tB(2,:)-tA(2,:).*tB(1,:)),dot(tA,tB));
    zsq = G(3,:).^2+CA(3,:).^2;
    R = 1./sqrt(1-zsq);
    R(~isfinite(R)) = 0;
    A = sum(R.^2.*(dtheta))/2;
end
