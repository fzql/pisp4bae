%Test cases
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
%% Brand new test cases
case_load_artificial

for i = 1:length(Q)
    [S,g1,g2] = pisp(Q{i},G{i});
    fprintf('Case %d (%s): ',i,fileName{i});
    switch S
        case -1
            fprintf('exterior\n');
        case 0
            fprintf('boundary\n');
        case 1
            fprintf('interior\n');
        otherwise
            fprintf('error\n');
    end
end

%% Practical Test Case
load institutions
load states
% Converting from spherical coordinates to Cartesian coordinates
tic
for i = 1:size(points,1)
    name = points{i,1};
    points{i,2} = pa2xyz(points{i,2}');
    where = cell(0);
    for j = 1:length(shapes)
        state = shapes{j};
        for k = 1:length(state)
            state{k} = pa2xyz(state{k}');
            %if pisp(coordinates,ring)==1
            %    where(length(where)+1) = names(j);
            %end
        end
    end
    % fprintf('%s: %s\n',name,strjoin(where,', '))
end
toc
% Calculating
tic
for i = 1:size(points,1)
    name = points{i,1};
    coordinates = points{i,2};
    where = cell(0);
    for j = 1:length(shapes)
        state = shapes{j};
        for k = 1:length(state)
            ring = state{k};
            if pisp(coordinates,ring)==1
                where(length(where)+1) = names(j);
            end
        end
    end
    fprintf('%s: %s\n',name,strjoin(where,', '))
end
toc
