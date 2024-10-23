%PISP_ROTATE PISP problem using Q-north rotation then projection
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
function [S,W,B1,B2,T] = pisp_rotate(Q,G)
    antipodal = false;
    if Q(3) < 0
        Q = -Q;
        antipodal = true;
    end
    a = Q(1);   b = Q(2);   c = Q(3);
    R = [1-a^2/(1+c) -a*b/(1+c) -a;
         -a*b/(1+c) 1-b^2/(1+c) -b;
         a b -(1-c^2)/(1+c)];
    T = R*G;
    [S,W,B] = pip(T(1,:),T(2,:));
    if antipodal
        Q = -Q;
        if ~isnan(W)
            W = -W;
            if W > 0
                S = 1;
            else
                S = -1;
            end
        end
    end
    if isnan(W)
        [S,B1,B2] = pisp_adt(Q,G,B);
    else
        B1 = B;
        B2 = B;
    end
    T(3,:) = [];
end
