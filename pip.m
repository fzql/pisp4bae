%PIP Decides the point-in-polygon (PiP) problem
%   [S,B] = pip(g) determines if the origin o(0,0) lies in the interior of,
%   on the boundary of, or to the exterior of an n-sided general polygon g.
%   The size of g is 2xn, where each column contains the Cartesian
%   coordinates of a vertex
%
%   Value of S: 1 (interior), 0 (boundary), -1 (exterior)
%   Values of B: Index of edges that contain o.
%   
%   Reference: Sunday (2021)
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
function [S,B] = pip(g)
    X = g(1,:);
    Y = g(2,:);
    n = length(X);
    W = 0;
    B = false(1,n);
    for I = 1:n
        if I<n
            J = I+1;
        else
            J = 1;
        end
        % Modification: Q-on-side judgement
        if X(I)*Y(J)-Y(I)*X(J)==0 && X(I)*X(J)<=0 && Y(I)*Y(J)<=0
            B(I) = true;
            W = nan;
        end % Modification ended
        if ~isnan(W)
            if Y(I)<=0
                if Y(J)>0
                    if isLeft(X(I),Y(I),X(J),Y(J)) > 0
                        W = W+1;
                    end
                end
            else
                if Y(J)<=0
                    if isLeft(X(I),Y(I),X(J),Y(J)) < 0
                        W = W-1;
                    end
                end
            end
        end
    end
    if any(B)
        S = 0;
    else
        if W>0
            S = 1;
        else 
            S = -1;
        end
    end
    B = find(B);
end

%ISLEFT Is the origin o(0,0) to the left of the geometric vector AB?
%   A = isLeft(x1,y1,x2,y2) calculates the signed area of the
%   triangle OAB specified by A(x1,y1) and B(x2,y2)
%
%   Sign of A:
%       If A is positive, then O is left of vector AB
%       If A is zero,     then O and vector AB are collinear
%       If A is negative, then O is right of vector AB
%
%   Reference: Sunday (2021)
function A = isLeft(x1,y1,x2,y2)
    A = x1*(y2-y1)-(x2-x1)*y1;
end
