%PISP_ROTATE PISP problem using shearing to the closest semi-axis
%   [S,W,B1,B2] = pisp_rotate([x y z],G) determines if the test point
%   Q(x,y,z) lies in a conventional spherical polygon G. Each
%   column of G represents the Cartesian coordinates of a vertex.
%   The unit sphere must be centered at the origin.
%
%   Value of S: 1 (interior), 0 (boundary), -1 (exterior).
%   Value of W: Winding number (or nan).
%   Values of B1: Index of edges that contain Q.
%   Values of B2: Index of edges that contain the antipode of Q.
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function [S,W,B1,B2,T] = pisp_shear(Q,G)
    a = Q(1);   b = Q(2);   c = Q(3);
    X = G(1,:); Y = G(2,:); Z = G(3,:);
    Q_1 = max(abs(Q));
    if abs(c) == Q_1
        U = X-(a/c)*Z; V = Y-(b/c)*Z;
        if c>0
            [S,W,B] = pip(U,V); T = [U;V];
        else
            [S,W,B] = pip(V,U); T = [V;U];
        end
    elseif abs(b) == Q_1
        U = Z-(c/b)*Y; V = X-(a/b)*Y;
        if b>0
            [S,W,B] = pip(U,V); T = [U;V];
        else
            [S,W,B] = pip(V,U); T = [V;U];
        end
    else
        U = Y-(b/a)*X; V = Z-(c/a)*X;
        if a>0
            [S,W,B] = pip(U,V); T = [U;V];
        else
            [S,W,B] = pip(V,U); T = [V;U];
        end
    end
    if isnan(W)
        [S,B1,B2] = pisp_adt(Q,G,B);
    else
        B1 = B;
        B2 = B;
    end
end
