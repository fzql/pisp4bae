%PISP_ADT Performs the antipode discrimination test
%   [S,B1,B2] = pisp_adt([x y z],G,B) determines if the test point
%   Q(x,y,z) lies in a conventional spherical polygon G. Each
%   column of G represents the Cartesian coordinates of a vertex.
%   The unit sphere must be centered at the origin.
%
%   Values of S: 1 (interior), 0 (boundary), -1 (exterior)
%   Values of W: Winding number (or nan)
%   Values of B1: Edge contains Q?
%   Values of B2: Edge antipodal to Q?
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function [S,B1,B2] = pisp_adt(Q,G,B)
    if ~any(B)
        B1 = B; B2 = B;
        return
    end
    n = size(G,2);
    B1 = false('like',B);
    B2 = false('like',B);
    for I = find(B)
        if I<n
            J = I+1;
        else 
            J = 1;
        end
        % Is OQ.OM>0?
        if dot(Q',mean(G(:,[I J]),2)) > 0
            B1(I) = true; B2(I) = false;
        else
            B1(I) = false; B2(I) = true;
        end
    end
    if any(B1)
        S = 1;
    else
        S = -1;
    end
end
