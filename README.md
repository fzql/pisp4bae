# pisp4bae

*Under active development.* A suite of tools that demonstrate the Projection-Winding-Orientation algorithm framework for great elliptic polygons on ellipsoids, including spherical polygons on spheres, that decide if a point is on the boundary, inside, or outside the ellipsoidal region.

- PiSP: Point-in-Spherical-Polygon
- PiGEP: Point-in-Great-Elliptic-Polygon
- PiGP: Point-in-Geodesic-Polygon

## What is an AEB-gon (antipodally extreme SP/GEP)?

A AEB-gon is a spherical polygon (SP) or a great elliptic polygon (GEP) whose boundary does not contain antipodal points. The following SPs or GEPs are AEB-gons:

- A spherical triangle (ST) or a great elliptic triangle (GET) that is not a closed hemisphere

- SPs or GEPs contained within any open hemisphere (HCed; hemispheric)

- SPs or GEPs whose interior contains a closed hemisphere (HCing)

- BAE-gons: A ST/GET that does not intersect its antipode

  - A BAE-gon is an antipodally small SP/GEP

- BAI-gons: A ST/GET that is complementary to a BAE-gon

  - A BAI-gon is an antipodally large SP/GEP

  - Two STs/GETs are complementary if they share the same topological boundary and their union is the entire sphere/ellipsoid

**Note:** No support is currently provided for compound SPs/GETs.

## Usage Example

Please review `test.m` for the PiSP problem. Call `pisp_shear.m` for the more optimal algorithm out of the two (compared to `pisp.m`).

Please review `test_pigp_via_pigep.m` (under review) for the PiGP problem.

Functions not described in this `README.md` are under active research or review.

## Current State

The [**PiSP manuscript**](https://dx.doi.org/10.1007/s11004-026-10282-0) is published in [*Mathematical Geosciences*](https://link.springer.com/journal/11004). If you have found it useful, please consider citing it.

    @article{Li2026Winding,
      Author  = {Li, Z. and Sun, J.},
      Title   = {Winding-based Point-Inclusion Tests for Spherical Polygons},
      Journal = {Mathematical Geosciences},
      Year    = {2026},
      DOI     = {10.1007/s11004-026-10282-0}
    }

The **PiGP-*via*-PiGEP manuscript** is under review.

More manuscripts are under way.

## Reference & Attributions

- `pip` is based on [Sunday (2021)](https://www.amazon.com/Practical-Geometry-Algorithms-C-Code/dp/B094T8MVJP).

- `states.mat` is sourced from [tl_2012_us_state.shp](https://www.sciencebase.gov/catalog/item/52c78623e4b060b9ebca5be5).

- `institutions.mat` is sourced manually from (a previous version of) [List of research universities in the United States](https://en.wikipedia.org/wiki/List_of_research_universities_in_the_United_States)
and Apple Maps.
