# pisp4bae

A suite of tools that demonstrate the Projection-Winding-Orientation algorithm framework
for great elliptic polygons on ellipsoids, including spherical polygons on spheres,
that decide if a point is on the boundary, inside, or outside the ellipsoidal region.

- PiSP: Point-in-Spherical-Polygon
- PiGEP: Point-in-Great-Elliptic-Polygon
- PiGP: Point-in-Geodesic-Polygon

## What is a BAE-gon?

A BAE-gon is a spherical polygon (SP) or a great elliptic polygon (GEP) whose boundary does not
contain antipodal points. The following SPs or GEPs are BAE-gons:

- A spherical triangle (ST) that is not a hemisphere

- Spherical polygons contained by an open hemisphere (HCed)

- Spherical polygons whose interior contains a closed hemisphere (HCing)

## Usage Example

Please review `test.m` for the PiSP problem and `test_pigp_via_pigep.m` for the PiGP problem.

Call `pisp_shear.m` for the more optimal algorithm out of the two (compared to `pisp.m`).

## Reference

Manuscript on the PiSP problem is accepted for publication in *Mathematical Geosciences*.

Manuscript on the PiGP via PiGEP problem is under preparation.

`pip` is based on [Sunday (2021)](https://www.amazon.com/Practical-Geometry-Algorithms-C-Code/dp/B094T8MVJP).

`states.mat` is sourced from
[tl_2012_us_state.shp](https://www.sciencebase.gov/catalog/item/52c78623e4b060b9ebca5be5).

`institutions.mat` is sourced manually from (a previous version of)
[List of research universities in the United States](https://en.wikipedia.org/wiki/List_of_research_universities_in_the_United_States)
and Apple Maps.
