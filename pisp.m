%PISP Point-in-spherical-polygon algorithm using Q-north rotation
%   S = pisp([a;b;c],G) determines if the given test point
%   Q(a,b,c) lies in the interior of, on the boundary of, or to the
%   exterior of a general spherical polygon G. The size of G is 3xn,
%   where each column contains the Cartesian coordinates of a vertex
%
%   The unit sphere must be centered at the origin
%
%   Value of S: 1 (interior), 0 (boundary), -1 (exterior).
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function S = pisp(Q,G)
    a = Q(1);
    b = Q(2);
    c = Q(3);
    n = size(G,2);
    % Step 1
    if c>-1
        R = [1-a^2/(1+c)  -a*b/(1+c) -a;...
              -a*b/(1+c) 1-b^2/(1+c) -b;...
               a           b          c];
    else
        R = [-1 0 0;0 1 0;0 0 -1];
    end
    G2 = R*G;
    % Step 2
    g1 = G2(1:2,:);
    [W,B] = pip(g1);
    if W>0
        S = 1; return
    elseif W<0
        S = -1; return
    elseif isnan(W)
        for i = B
            j = mod(i,n)+1;
            if G2(3,i)+G2(3,j)>0
                S = 0; return
            end
        end
    end
    % Step 3
    A = boundedArea(G2);
    S = sign(A);
    if abs(A)<5*eps
        warning('G is close to null-oriented.')
    end
end
