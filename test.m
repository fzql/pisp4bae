%Test cases
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
%% Artificial Test Case
pa2xyz = @(p,a) [sin(p)*cos(a) sin(p)*sin(a) cos(p)];
Q{1} = pa2xyz(0,0); % Test point Cartesian coordinates
G{1} = [1  0  0;    % Each column of G{k} is a vertex
        0  0  1;
        0 -1  0];
Q{2} = pa2xyz(0,0);
G{2} = [      1/2  0              -1/2 ;
                0  1/sqrt(2)       0 ;
        sqrt(3)/2  1/sqrt(2) sqrt(3)/2];
Q{3} = pa2xyz(pi/2,pi/4);
G{3} = [sqrt(7)/4       sqrt(7)/4   1/sqrt(8) ; % P2P5 cap P7P10
              3/4       sqrt(3)/4   1/2       ; % P2 ( 60,30)
              1               0     0         ; % P3 ( 90, 0)
              3/4       sqrt(3)/4  -1/2       ; % P4 (120,30)
              1/2       sqrt(3)/2   0         ; % P5 ( 90,60)
              1/sqrt(2)  sqrt(3/8)  1/sqrt(8) ; % v1
        sqrt(3)/2             1/2   0         ; % P7 ( 90,30)
        sqrt(3)/4             3/4  -1/2       ; % P8 (120,60)
              0               1     0         ; % P9 ( 90,90)
        sqrt(3)/4             3/4   1/2     ]'; % P10( 60,60)
Q{4} = pa2xyz(pi-atan(sqrt(5)),-asin(1/sqrt(5)));
G{4} = [1  0  0;
        0  0 -1;
        0 -1  0];
for k = 1:length(Q)
    [S,W,B1,B2,T] = pisp_rotate(Q{k},G{k});
    fprintf('#%dR: S %2d, wn %2d, edges %d/%d\n',...
        k,S,W,nnz(B1),nnz(B2)); T'
    [S,W,B1,B2,T] = pisp_shear(Q{k},G{k});
    fprintf('#%dS: S %2d, wn %2d, edges %d/%d\n',...
        k,S,W,nnz(B1),nnz(B2)); T'
end
%% Practical Test Case
load institutions
load states
tic
for i = 1:size(points,1)
    name = points{i,1};
    coordinates = points{i,2};
    where = cell(0);
    for j = 1:length(shapes)
        state = shapes{j};
        for k = 1:length(state)
            ring = state{k};
            if pisp_shear(ap2xyz(coordinates),ap2xyz(ring)')==1
                where(length(where)+1) = names(j);
            end
        end
    end
    %fprintf('%s: %s\n',name,strjoin(where,', '))
end
toc

%% Generate tikz pictures
P = [1 0 0;0 1 0;0 0 1];
nView = [1 1 1];
pisp2tikz(P,'test')

%% Generate tikz pictures
P = [1 0 0;0 0 -1;0 1 0];
nView = [1;1;1];
pisp2tikz(P,'test',nView)
