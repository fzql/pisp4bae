%TEST_PIGEP Test script for Point-In-Great-Elliptic-Plane (PIGEP) calculations
%
%   This script performs the following:
%   1. Defines WGS84 ellipsoid parameters.
%   2. Defines the US Caribbean Sea ECA boundary polygon.
%   3. Converts geodetic coordinates to Earth-Centered Earth-Fixed (ECEF) Cartesian coordinates.
%   4. Computes the Great Elliptic Arc lengths for each edge.
%   5. Computes the distance from a test point (Saint Little James Island) to the
%      great elliptic plane of each edge.
%   6. Tests the Point-In-Spherical-Polygon (PISP) algorithm.
%
%   MIT License
%   Copyright (c) 2023--2026 Ziqiang Li, Jindi Sun

% --- Configuration ---
clear; clc; % Start with a clean slate

% --- WGS84 Parameters ---
a = 6378137.0;          % Semi-major axis (meters)
b = a;                  % Semi-major axis (meters)
f = 1/298.257223563;    % Flattening
c = a * (1 - f);        % Semi-minor axis (meters)

% --- Theoretical Constant k_theory ---
% Approximation for deflection constant
k_theory = max((a-c)/b^2, (a-b)/c^2) / 8;

fprintf('WGS84 Parameters:\n');
fprintf('  a = %.4f m\n', a);
fprintf('  c = %.4f m\n', c);
fprintf('  f = 1/%.9f\n', 1/f);
fprintf('  k_theory = %.16g\n', k_theory);

% --- US Caribbean Sea ECA Coordinates ---
% Source: MARPOL Annex VI, Appendix VII
% Format: [LatDeg, LatMin, LatSec, LonDeg, LonMin, LonSec]
% Note: West longitudes are treated as negative.
ECA_coords = [
    17, 18, 37, 67, 32, 14;
    19, 11, 14, 67, 26, 45;
    19, 30, 28, 65, 16, 48;
    19, 12, 25, 65,  6,  8;
    18, 45, 13, 65,  0, 22;
    18, 41, 14, 64, 59, 33;
    18, 29, 22, 64, 53, 51;
    18, 27, 35, 64, 53, 22;
    18, 25, 21, 64, 52, 39;
    18, 24, 30, 64, 52, 19;
    18, 23, 51, 64, 51, 50;
    18, 23, 42, 64, 51, 23;
    18, 23, 36, 64, 50, 17;
    18, 23, 48, 64, 49, 41;
    18, 24, 11, 64, 49,  0;
    18, 24, 28, 64, 47, 57;
    18, 24, 18, 64, 47,  1;
    18, 23, 13, 64, 46, 37;
    18, 22, 37, 64, 45, 20;
    18, 22, 39, 64, 44, 42;
    18, 22, 42, 64, 44, 36;
    18, 22, 37, 64, 44, 24;
    18, 22, 39, 64, 43, 42;
    18, 22, 30, 64, 43, 36;
    18, 22, 25, 64, 42, 58;
    18, 22, 26, 64, 42, 28;
    18, 22, 15, 64, 42,  3;
    18, 22, 22, 64, 38, 23;
    18, 21, 57, 64, 40, 60;
    18, 21, 51, 64, 40, 15;
    18, 21, 22, 64, 38, 16;
    18, 20, 39, 64, 38, 33;
    18, 19, 15, 64, 38, 14;
    18, 19,  7, 64, 38, 16;
    18, 17, 23, 64, 39, 38;
    18, 16, 43, 64, 39, 41;
    18, 11, 33, 64, 38, 58;
    18,  3,  2, 64, 38,  3;
    18,  2, 56, 64, 29, 35;
    18,  2, 51, 64, 27,  2;
    18,  2, 30, 64, 21,  8;
    18,  2, 31, 64, 20,  8;
    18,  2,  3, 64, 15, 57;
    18,  0, 12, 64,  2, 29;
    17, 59, 58, 64,  1,  4;
    17, 58, 47, 63, 57,  1;
    17, 57, 51, 63, 53, 54;
    17, 56, 38, 63, 53, 21;
    17, 39, 40, 63, 54, 53;
    17, 37,  8, 63, 55, 10;
    17, 30, 21, 63, 55, 56;
    17, 11, 36, 63, 57, 57;
    17,  4, 60, 63, 58, 41;
    16, 59, 49, 63, 59, 18;
    17, 18, 37, 67, 32, 14
];

% Convert DMS to decimal degrees
lat_deg = ECA_coords(:,1) + ECA_coords(:,2)/60 + ECA_coords(:,3)/3600;
lon_deg = -(ECA_coords(:,4) + ECA_coords(:,5)/60 + ECA_coords(:,6)/3600);

% Convert to Radians
phi = deg2rad(lat_deg);
lam = deg2rad(lon_deg);

% Convert to Cartesian coordinates (ECEF)
e_sq = 1 - (c/a)^2;
N = a ./ sqrt(1 - e_sq * sin(phi).^2);

X = N .* cos(phi) .* cos(lam);
Y = N .* cos(phi) .* sin(lam);
Z = N * (1 - e_sq) .* sin(phi);

eca_cartesian = [X, Y, Z];

% --- Test Point: Saint Little James Island ---
slj_lat = 18 + 18/60 + 0/3600;
slj_lon = -(64 + 49/60 + 31/3600);
slj_phi = deg2rad(slj_lat);
slj_lam = deg2rad(slj_lon);
slj_N = a ./ sqrt(1 - e_sq * sin(slj_phi).^2);
slj_X = slj_N .* cos(slj_phi) .* cos(slj_lam);
slj_Y = slj_N .* cos(slj_phi) .* sin(slj_lam);
slj_Z = slj_N * (1 - e_sq) .* sin(slj_phi);

Q_test = [slj_X; slj_Y; slj_Z];

% Loop through edges
num_points = size(eca_cartesian, 1);
total_length = 0;

fprintf('\n--- Edge Analysis ---\n');
fprintf('%-6s %-15s %-15s %-15s\n', 'Edge', 'Length (km)', 'Theory (m)', 'Plane Dist (m)');

for i = 1:num_points-1
    P_start = eca_cartesian(i, :);
    P_end = eca_cartesian(i+1, :);
    
    % Generate arc points
    [arc_pts, segment_len] = compute_great_elliptic_arc(P_start, P_end, a, b, c, 100);
    
    km = segment_len / 1000;
    dm = k_theory * segment_len^2;
    
    % Compute distance from Test Point to the great elliptic plane
    plane_normal = cross(P_start, P_end);
    plane_unit_normal = plane_normal / norm(plane_normal);
    dist_plane = abs(dot(Q_test', plane_unit_normal));
    
    fprintf('%-6d %-15.4f %-15.6g %-15.4f\n', i, km, dm, dist_plane);
    total_length = total_length + segment_len;
end

fprintf('------------------------------------------------------------\n');
fprintf('Total Perimeter: %.4f km\n', total_length / 1000);

% --- Local Functions ---

function [pts, len] = compute_great_elliptic_arc(p1, p2, a, b, c, n)
%COMPUTE_GREAT_ELLIPTIC_ARC Computes points and length of a great elliptic arc.
%
%   [pts, len] = compute_great_elliptic_arc(p1, p2, a, b, c, n)
%
%   Inputs:
%       p1, p2  - Start and end points (Cartesian, 1x3)
%       a, b, c - Ellipsoid semi-axes
%       n       - Number of points for interpolation
%
%   Outputs:
%       pts     - nx3 matrix of points along the arc
%       len     - Length of the arc in meters

    % Map start/end points to the unit sphere
    u1 = p1 ./ [a, b, c];
    u2 = p2 ./ [a, b, c];
    
    % Normalize to ensure they are exactly on the unit sphere
    u1 = u1 / norm(u1);
    u2 = u2 / norm(u2);
    
    % Compute angle omega between vectors
    dp = dot(u1, u2);
    dp = max(min(dp, 1), -1); % Clamp to [-1, 1]
    omega = acos(dp);
    sin_omega = sin(omega);
    
    % Handle coincident or antipodal points
    if abs(sin_omega) < 1e-12
        pts = [p1; p2];
        len = norm(p1 - p2);
        return;
    end
    
    % Generate interpolation parameter t
    t = linspace(0, 1, n)';
    
    % Spherical Linear Interpolation (SLERP)
    s1 = sin((1-t)*omega) / sin_omega;
    s2 = sin(t*omega) / sin_omega;
    
    u_interp = s1 .* u1 + s2 .* u2;
    
    % Map back to ellipsoid
    pts = u_interp .* [a, b, c];
    
    % Compute length by summing Euclidean distances of segments
    d = diff(pts, 1, 1);
    len = sum(sqrt(sum(d.^2, 2)));
end

% --- PISP4BAE Test ---
Q_test = [slj_X; slj_Y; slj_Z];

% Remove the repeated last point for the polygon definition and reverse orientation
G_poly = flipud(eca_cartesian(1:end-1, :))';
G_IS_ANTIPODALLY_SMALL = true;
S = pisp4bae(Q_test, G_poly, G_IS_ANTIPODALLY_SMALL);
fprintf('pisp4bae result (S): %d\n', S);
fprintf('Expected S = 1\n')
