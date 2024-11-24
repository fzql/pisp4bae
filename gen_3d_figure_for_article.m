%% ADT Case 1
Q{1} = [0 0 1];
P{1} = [ 1/sqrt(2) 0         1/sqrt(2) ;
         0         1/sqrt(2) 1/sqrt(2) ;
        -1/sqrt(2) 0         1/sqrt(2)];
nView{1} = [1 1 1];
fileName{1} = 'case-adt-1';
pisp2tikz(Q{1},P{1},nView{1},fileName{1})

%% ADT Case 2
Q{2} = [0 1 0];
P{2} = [1 0          0         ;
        0 1/sqrt(2)  1/sqrt(2) ;
        0 1/sqrt(2) -1/sqrt(2)];
nView{2} = [1 1 1];
fileName{2} = 'case-adt-2';
pisp2tikz(Q{2},P{2},nView{2},fileName{2})

%% ADT Case 3
Q{3} = [0 0 -1];
P{3} = [ 1/sqrt(2) 0  1/sqrt(2);
        -1/sqrt(2) 0  1/sqrt(2);
        -1/sqrt(2) 0 -1/sqrt(2);
         1/sqrt(2) 0 -1/sqrt(2)];
nView{3} = [1 1 1];
fileName{3} = 'case-adt-3';
pisp2tikz(Q{3},P{3},nView{3},fileName{3})

%% WIND Case 1
n = 12;
zs = [0 0.9 -0.9];
for c = length(zs)
    s = 3+c;
    Q{s} = [0 0 1];
    P{s} = zeros(n,3);
    nView{s} = [1 1 1];
    z = zs(c);
    r = sqrt(1-z^2);
    for k = 1:n
        angle = k*pi/6;
        P{s}(k,:) = [r*cos(angle) r*sin(angle) z];
    end
    fileName{s} = sprintf('case-wind-1-%d',c);
    pisp2tikz(Q{s},P{s},nView{s},fileName{s})
end
return

%% WIND Case 2
n = 12;
ys = [0 0.9 -0.9];
for c = 1:length(ys)
    s = 6+c;
    Q{s} = [0 1 0];
    P{s} = zeros(n,3);
    nView{s} = [1 1 1];
    y = ys(c);
    r = sqrt(1-y^2);
    for k = 1:n
        angle = k*pi/6;
        P{s}(k,:) = [r*cos(angle) y r*sin(angle)];
    end
    fileName{s} = sprintf('case-wind-2-%d',c);
    pisp2tikz(Q{s},P{s},nView{s},fileName{s})
end

%% WIND Case 3
Q{10} = [1/sqrt(2) 1/sqrt(2) 0];
Pint = [sqrt(3/44*(5+  sqrt(3))), ...
        sqrt(3/44*(5+  sqrt(3))), ...
        sqrt(1/22*(7-3*sqrt(3)))];
P{10} = [Pint                                 ; % P0 = P1P4 cap P6P9
              3/4       sqrt(3)/4   1/2      ; % P1( 60,30)
              1               0     0        ; % P2( 90, 0)
              3/4       sqrt(3)/4  -1/2      ; % P3(120,30)
              1/2       sqrt(3)/2   0        ; % P4( 90,60)
        Pint                                 ; % P5 = P0
        sqrt(3)/2             1/2   0        ; % P6( 90,30)
        sqrt(3)/4             3/4  -1/2      ; % P7(120,60)
              0               1     0        ; % P8( 90,90)
        sqrt(3)/4             3/4   1/2      ];% P9( 60,60)
nView{10} = [1 1 0];
fileName{10} = 'case-wind-3';
pisp2tikz(Q{10},P{10},nView{10},fileName{10})

%% ORIENTATION Case 1
Q{11} = [0 0  1];
P{11} = [0 0 -1;
         1 0  0;
         0 1  0];
nView{11} = [1 1 1];
fileName{11} = 'case-orientation-1';
pisp2tikz(Q{11},P{11},nView{11},fileName{11})

%% ORIENTATION Case 2
Q{12} = [0 0  1];
P{12} = [0 0 -1;
         0 1  0;
         1 0  0];
nView{12} = [1 1 1];
fileName{12} = 'case-orientation-2';
pisp2tikz(Q{12},P{12},nView{12},fileName{12})

%% WIND Case 3
n = 12;
xs = [0.9 -0.9];
for c = 1:length(xs)
    s = 12+c;
    Q{s} = [0 0 1];
    P{s} = zeros(n,3);
    nView{s} = [1 1 1];
    x = xs(c);
    r = sqrt(1-x^2);
    for k = 1:n
        angle = k*pi/6;
        P{s}(k,:) = [x r*cos(angle) r*sin(angle)];
    end
    fileName{s} = sprintf('case-orientation-3-%d',c);
    pisp2tikz(Q{s},P{s},nView{s},fileName{s})
end
