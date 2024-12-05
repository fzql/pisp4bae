%% Test cases
%
% MIT License
% Copyright (c) 2023--2024 Ziqiang Li, Jindi Sun
%% Brand new test cases
case_load_artificial
fprintf('Judging artificial cases...\n')
tic
for i = 1:length(Q)
    S = pisp(Q{i},G{i}');
    fprintf('\tCase %d (%s): ',i,fileName{i});
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
toc

%% Practical Test Case
load institutions
load states
% Converting from spherical coordinates to Cartesian coordinates
fprintf('Converting coordinates for real cases...\n')
tic
for i = 1:size(points,1)
    latlon = points{i,2}';
    points{i,2} = pa2xyz([pi/2-latlon(1);latlon(2)]);
end
for i = 1:length(shapes)
    for j = 1:length(shapes{i})
        latlon = fliplr(shapes{i}{j}');
        shapes{i}{j} = pa2xyz([pi/2-latlon(1,:);latlon(2,:)]);
    end
end
toc
% Calculating
fprintf('Judging real cases...\n')
tic
where = cell(size(points,1),1);
for i = 1:size(points,1)
    name = points{i,1};
    coordinates = points{i,2};
    for j = 1:length(shapes)
        state = shapes{j};
        for k = 1:length(state)
            ring = state{k};
            if pisp(coordinates,ring)==1
                where{i}(end+1) = names(j);
            end
        end
    end
end
toc
for i = 1:size(points,1)
    name = points{i,1};
    results = strjoin(where{i},', ');
    fprintf('\t%s: %s\n',name,results)
end
