%PISP4BAE Point-in-spherical-polygon algorithm w/ shearing transformation
%   S = pisp4bae([a;b;c],G,E) determines if the given test point
%   Q(a,b,c) lies in the interior of, on the boundary of, or to the
%   exterior of a BAE/BAI-gon G (E=true/false). The size of G is 3xn,
%   where each column contains the Cartesian coordinates of a vertex
%
%   The unit sphere must be centered at the origin
%
%   Value of S: 1 (interior), 0 (boundary), -1 (exterior).
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function [S,w,B,cn] = pisp4bae(Q,G,E)
    a = Q(1);
    b = Q(2);
    c = Q(3);
    n = size(G,2);
    X = G(1,:); Y = G(2,:); Z = G(3,:);
    % Step 1
    Q_1 = max(abs(Q));
    if abs(c) == Q_1
        U = c*X-a*Z;
        V = c*Y-b*Z;
        if c>0
            [w,B,cn] = pip([U;V]);
        else
            [w,B,cn] = pip([V;U]);
        end
    elseif abs(b) == Q_1
        U = b*Z-c*Y;
        V = b*X-a*Y;
        if b>0
            [w,B,cn] = pip([U;V]);
        else
            [w,B,cn] = pip([V;U]);
        end
    else
        U = a*Y-b*X;
        V = a*Z-c*X;
        if a>0
            [w,B,cn] = pip([U;V]);
        else
            [w,B,cn] = pip([V;U]);
        end
    end
    % Step 2
    if w>0
        S = 1;
    elseif w<0
        S = -1;
    elseif w==0
        if E
            S = -1;
        else
            S = 1;
        end
    else
        i = B(1);
        j = mod(i,n)+1;
        if dot(G(:,i)+G(:,j),Q)>0
            S = 0;
        elseif E
            S = -1;
        else
            S = 1;
        end
    end
end
