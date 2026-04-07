%GEALEN Approximates the length and points of a Great Elliptic Arc (GEA)
%   [pts,len] = gealen(A,B,a,b,c,n) computes the arc length through n
%   partitions of the great elliptic arc between p1 and p2 on a triaxial
%   ellipsoid with semi-axes length a, b, and c. When mapped onto the unit
%   sphere, the partitions are uniform. A simple sum of Euclidean distances
%   serves as an approximation of the arc length.
function [pts,len] = gealen(A,B,a,b,c,n)
    % Handle antipodal points
    if all(A+B==0)
        error('not implemented for antipodal points')
    end

    % Handle identical points
    if all(A==B)
        pts = A;
        len = 0;
        return;
    end
    
    % Map start/end points to the unit sphere
    U = normalize(A./[a b c],'norm');
    V = normalize(B./[a b c],'norm');
    
    % Compute angle omega between vectors
    omega = acos(max(min(dot(U, V), 1), -1));
    sino = sin(omega);
    
    % Generate interpolation parameter t
    t = linspace(0,1,n)';
    
    % Spherical Linear Interpolation (SLERP)
    sU = sin((1-t)*omega)/sino;
    sV = sin(t*omega)/sino;
    
    u_interp = sU.*U+sV.*V;
    
    % Map back to ellipsoid
    pts = u_interp.*[a b c];
    
    % Compute length by summing Euclidean distances of segments
    d = diff(pts,1,1);
    len = sum(sqrt(sum(d.^2, 2)));
end
