%PISP4BAE Point-in-spherical-polygon algorithm w/ shearing transformation
%   S = pisp4bae([a;b;c],G) determines if the given test point
%   Q(a,b,c) lies in the interior of, on the boundary of, or to the
%   exterior of a BAE-polygon G. The size of G is 3xn,
%   where each column contains the Cartesian coordinates of a vertex
%
%   The unit sphere must be centered at the origin
%
%   Value of S: 1 (interior), 0 (boundary), -1 (exterior).
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function S = pisp4bae(Q,G)
    a = Q(1);
    b = Q(2);
    c = Q(3);
    n = size(G,2);
    X = G(1,:); Y = G(2,:); Z = G(3,:);
    % Step 1
    Q_1 = max(abs(Q));
    if abs(c) == Q_1
        U = X-(a/c)*Z;
        V = Y-(b/c)*Z;
        if c>0
            [w,B] = pip([U;V]);
        else
            [w,B] = pip([V;U]);
        end
    elseif abs(b) == Q_1
        U = Z-(c/b)*Y;
        V = X-(a/b)*Y;
        if b>0
            [w,B] = pip([U;V]);
        else
            [w,B] = pip([V;U]);
        end
    else
        U = Y-(b/a)*X;
        V = Z-(c/a)*X;
        if a>0
            [w,B] = pip([U;V]);
        else
            [w,B] = pip([V;U]);
        end
    end
    % Step 2
    if w>0
        S = 1;
    elseif w<=0
        S = -1;
    else
        i = B(1);
        j = mod(i,n)+1;
        if dot(G(:,i)+G(:,j),Q)>0
            S = 0;
        else
            S = -1;
        end
    end
end
