% PISP2TIKZ
% PISP2TIKZ(p, fileName)
%   Q test point
%   P each row is a vertex
%   fileName is the output file name
%   nView viewing from nView
function pisp2tikz(Q,P,nView,fileName)

texFileName = strcat(fileName,'.tex');
f = fopen(texFileName,'w');

nView = nView/vecnorm(nView);
% nView=[1; 1; 1], az = 54.7356, el = 135
az = rad2deg(asin(vecnorm(nView(1:2))));
el = rad2deg(atan2(nView(1),-nView(2)));
radius = 3;
n = size(P,1);

% Pole calculation and degenerate arc generation
% \tdplotdefinepoints doesn't use these poles
% they are really only for user convenience
pole = cross(P,P([2:end 1],:),2);
arcLengthSin = vecnorm(pole,2,2);
arcLength = asin(arcLengthSin);
degenerate = arcLength==0;
if any(degenerate)
    pole(degenerate,:) = repmat([0 0 1],nnz(degenerate),1);
end
arcLengthSin(degenerate) = 1;
pole = pole./arcLengthSin(:);

B = cross(pole,P,2);

% z-buffering cutoff calculation
depth = P*nView';
depthAltSign = depth.*depth([2:end 1])<0;
mP = zeros(size(P));
for i = find(depthAltSign)'
    angle = atan2(P(i,:)*nView',-B(i,:)*nView');
    if angle<0
        angle = angle+pi;
    end
    mP(i,:) = cos(angle)*P(i,:)+sin(angle)*B(i,:);
end

fprintf(f,"\\documentclass{standalone}\n");
fprintf(f,"\\usepackage{tikz,tikz-3dplot}\n");
fprintf(f,"\\usetikzlibrary{decorations.markings}\n");
fprintf(f,"%% nView = [%g;%g;%g];\n",nView(1),nView(2),nView(3));
fprintf(f,"\\tdplotsetmaincoords{%g}{%g}\n",az,el);
fprintf(f,"\\begin{document}\n");
fprintf(f,"\\begin{tikzpicture}[]\n");

fprintf(f,"\\pgfmathsetmacro{\\r}{%g}\n",radius);

%% BACKSIDE
fprintf(f,"\n");
fprintf(f,"%%%% Negative depth\n");
fprintf(f,"\\begin{scope}[tdplot_main_coords]\n");

% Useful points
fprintf(f,"\\coordinate (O) at (0,0,0);\n");
fprintf(f,"\\coordinate (X) at (1.5*\\r,0,0);\n");
fprintf(f,"\\coordinate (Y) at (0,1.5*\\r,0);\n");
fprintf(f,"\\coordinate (Z) at (0,0,1.5*\\r);\n");
fprintf(f,"\\coordinate (N) at (0,0,\\r);\n");
fprintf(f,"\\coordinate (S) at (0,0,-\\r);\n");
fprintf(f,"\\coordinate (E) at (0,\\r,0);\n");
fprintf(f,"\\coordinate (W) at (0,-\\r,0);\n");
fprintf(f,"\\coordinate (F) at (\\r,0,0);\n");
fprintf(f,"\\coordinate (B) at (-\\r,0,0);\n");
fprintf(f,"\\coordinate (Q) at (%g,%g,%g); %%(%g,%g,%g)\n", ...
    radius*Q(1),radius*Q(2),radius*Q(3),Q(1),Q(2),Q(3));
fprintf(f,"%% vertices\n");
for i = 1:n
    fprintf(f,"\\coordinate (P%d) at (%g,%g,%g); %%(%g,%g,%g)\n",i-1,...
        radius*P(i,1),radius*P(i,2),radius*P(i,3), ...
        P(i,1),P(i,2),P(i,3));
end
fprintf(f,"%% poles\n");
for i = 1:n
    fprintf(f,"\\coordinate (p%d) at (%g,%g,%g); %%(%g,%g,%g)\n",i-1,...
        radius*pole(i,1),radius*pole(i,2),radius*pole(i,3), ...
        pole(i,1),pole(i,2),pole(i,3));
end

% Drawing axes
fprintf(f,"%% Axes\n");
fprintf(f,"\\draw[dashed] (O)--(F);\n");
fprintf(f,"\\draw[dashed] (O)--(E);\n");
fprintf(f,"\\draw[dashed] (O)--(N);\n");

% Drawing arcs
for i = 1:n
    j = mod(i,n)+1;
    if degenerate(i)
        fprintf(f,"%% arc from P%d to P%d (degenerate)\n",i-1,j-1);
        continue
    elseif depth(i)>=0&&depth(j)>=0
        fprintf(f,"%% arc from P%d to P%d (cutoff)\n",i-1,j-1);
        continue
    end
    
    if depthAltSign(i)
        if depth(i)<0
            fprintf(f,"%% arc from P%d to P%d (first half)\n",i-1,j-1);
            fprintf(f,"\\tdplotdefinepoints(0,0,0)(%g,%g,%g)(%g,%g,%g)\n", ...
                P(i,1),P(i,2),P(i,3),mP(i,1),mP(i,2),mP(i,3));
            fprintf(f,"\\tdplotdrawpolytopearc[thick,dashed]{\\r}{}{}\n");
        else
            fprintf(f,"%% arc from P%d to P%d (second half)\n",i-1,j-1);
            fprintf(f,"\\tdplotdefinepoints(0,0,0)(%g,%g,%g)(%g,%g,%g)\n", ...
                mP(i,1),mP(i,2),mP(i,3),P(j,1),P(j,2),P(j,3));
            fprintf(f,"\\tdplotdrawpolytopearc[thick,dashed,decoration={\n");
            fprintf(f,"  markings,\n");
            fprintf(f,"  mark=at position 0 with {\\arrow{>}}\n");
            fprintf(f,"},postaction={decorate}]{\\r}{}{}\n");
        end
    else
        fprintf(f,"%% arc from P%d to P%d\n",i-1,j-1);
        fprintf(f,"\\tdplotdefinepoints(0,0,0)(%g,%g,%g)(%g,%g,%g)\n", ...
            P(i,1),P(i,2),P(i,3),P(j,1),P(j,2),P(j,3));
        fprintf(f,"\\tdplotdrawpolytopearc[thick,dashed,decoration={\n");
            fprintf(f,"  markings,\n");
            fprintf(f,"  mark=at position 0.5 with {\\arrow{>}}\n");
            fprintf(f,"},postaction={decorate}]{\\r}{}{}\n");
    end
end

% Important labels
fprintf(f,"\\path[fill=black] (O) circle (1pt) node[anchor=3*30]{$O$};\n");

% Drawing vertices
for i = find(depth<0)'
    fprintf(f,"%% vertex %d\n",i-1);
    fprintf(f,"\\path[fill=black] (P%d) circle (1pt) node[anchor=0*30]{$P_{%d}$};\n",...
        i-1,i-1);
end

% Drawing test point
if dot(nView,Q)<0
    fprintf(f,"%% Test point\n");
    fprintf(f,"\\path[fill=black] (Q) circle (1pt) node[anchor=0*30]{$Q$};\n");
end

fprintf(f,"\\end{scope}\n");
fprintf(f,"\n");

%% BALL
fprintf(f,"\\fill[ball color=white!10,opacity=0.1] (0,0,0) circle (\\r);\n");

%% FRONT SIDE
fprintf(f,"\n");
fprintf(f,"%%%% Positive depth\n");
fprintf(f,"\\begin{scope}[tdplot_main_coords]\n");

% Useful points
fprintf(f,"\\coordinate (O) at (0,0,0);\n");
fprintf(f,"\\coordinate (X) at (1.5*\\r,0,0);\n");
fprintf(f,"\\coordinate (Y) at (0,1.5*\\r,0);\n");
fprintf(f,"\\coordinate (Z) at (0,0,1.5*\\r);\n");
fprintf(f,"\\coordinate (N) at (0,0,\\r);\n");
fprintf(f,"\\coordinate (S) at (0,0,-\\r);\n");
fprintf(f,"\\coordinate (E) at (0,\\r,0);\n");
fprintf(f,"\\coordinate (W) at (0,-\\r,0);\n");
fprintf(f,"\\coordinate (F) at (\\r,0,0);\n");
fprintf(f,"\\coordinate (B) at (-\\r,0,0);\n");
fprintf(f,"\\coordinate (Q) at (%g,%g,%g); %%(%g,%g,%g)\n", ...
    radius*Q(1),radius*Q(2),radius*Q(3),Q(1),Q(2),Q(3));
fprintf(f,"%% vertices\n");
for i = 1:n
    fprintf(f,"\\coordinate (P%d) at (%g,%g,%g); %%(%g,%g,%g)\n",i-1,...
        radius*P(i,1),radius*P(i,2),radius*P(i,3), ...
        P(i,1),P(i,2),P(i,3));
end
fprintf(f,"%% poles\n");
for i = 1:n
    fprintf(f,"\\coordinate (p%d) at (%g,%g,%g); %%(%g,%g,%g)\n",i-1,...
        radius*pole(i,1),radius*pole(i,2),radius*pole(i,3), ...
        pole(i,1),pole(i,2),pole(i,3));
end

% Drawing axes
fprintf(f,"%% Axes\n");
if nView(1)>=0
    fprintf(f,"\\draw[->] (F)--(X) node[anchor=3*30] {$x$};\n");
end
if nView(2)>=0
    fprintf(f,"\\draw[->] (E)--(Y) node[anchor=3*30] {$y$};\n");
end
if nView(3)>=0
    fprintf(f,"\\draw[->] (N)--(Z) node[anchor=6*30] {$z$};\n");
end

% Drawing arcs
for i = 1:n
    j = mod(i,n)+1;
    if degenerate(i)
        fprintf(f,"%% arc from P%d to P%d (degenerate)\n",i-1,j-1);
        continue
    elseif depth(i)<=0&&depth(j)<0||depth(i)<0&&depth(j)<=0
        fprintf(f,"%% arc from P%d to P%d (cutoff)\n",i-1,j-1);
        continue
    end
    
    if depthAltSign(i)
        if depth(i)>0
            fprintf(f,"%% arc from P%d to P%d (first half)\n",i-1,j-1);
            fprintf(f,"\\tdplotdefinepoints(0,0,0)(%g,%g,%g)(%g,%g,%g)\n", ...
                P(i,1),P(i,2),P(i,3),mP(i,1),mP(i,2),mP(i,3));
            fprintf(f,"\\tdplotdrawpolytopearc[thick]{\\r}{}{}\n");
        else
            fprintf(f,"%% arc from P%d to P%d (second half)\n",i-1,j-1);
            fprintf(f,"\\tdplotdefinepoints(0,0,0)(%g,%g,%g)(%g,%g,%g)\n", ...
                mP(i,1),mP(i,2),mP(i,3),P(j,1),P(j,2),P(j,3));
            fprintf(f,"\\tdplotdrawpolytopearc[thick,decoration={\n");
            fprintf(f,"  markings,\n");
            fprintf(f,"  mark=at position 0 with {\\arrow{>}}\n");
            fprintf(f,"},postaction={decorate}]{\\r}{}{}\n");
        end
    else
        fprintf(f,"%% arc from P%d to P%d\n",i-1,j-1);
        fprintf(f,"\\tdplotdefinepoints(0,0,0)(%g,%g,%g)(%g,%g,%g)\n", ...
            P(i,1),P(i,2),P(i,3),P(j,1),P(j,2),P(j,3));
        fprintf(f,"\\tdplotdrawpolytopearc[thick,decoration={\n");
            fprintf(f,"  markings,\n");
            fprintf(f,"  mark=at position 0.5 with {\\arrow{>}}\n");
            fprintf(f,"},postaction={decorate}]{\\r}{}{}\n");
    end
end

% Drawing vertices
for i = find(depth>=0)'
    fprintf(f,"%% vertex %d\n",i-1);
    fprintf(f,"\\path[fill=black] (P%d) circle (1pt) node[anchor=0*30]{$P_{%d}$};\n",...
        i-1,i-1);
end

% Drawing test point
if dot(nView,Q)>=0
    fprintf(f,"%% Test point\n");
    fprintf(f,"\\path[fill=black] (Q) circle (1pt) node[anchor=0*30]{$Q$};\n");
end

fprintf(f,"\\end{scope}\n");
fprintf(f,"\n");

fprintf(f,"\\end{tikzpicture}\n");
fprintf(f,"\\end{document}\n");

fclose(f);

texCommand = strcat("pdflatex -halt-on-error ",texFileName);
system(texCommand);

end

