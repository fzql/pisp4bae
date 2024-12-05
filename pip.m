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
function [w,B] = pip(g)
    x = g(1,:);
    y = g(2,:);
    n = size(g,2);
    w = 0;
    b = false(1,n);
    for i = 1:n
        j = mod(i,n)+1;
        % Modification: Q-on-side judgement
        if x(i)*y(j)-y(i)*x(j)==0 && x(i)*x(j)<=0 && y(i)*y(j)<=0
            b(i) = true;
            w = nan;
        end % Modification ended
        if ~isnan(w)
            if y(i)<=0
                if y(j)>0
                    if isLeft(x(i),y(i),x(j),y(j)) > 0
                        w = w+1;
                    end
                end
            else
                if y(j)<=0
                    if isLeft(x(i),y(i),x(j),y(j)) < 0
                        w = w-1;
                    end
                end
            end
        end
    end
    B = find(b);
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
