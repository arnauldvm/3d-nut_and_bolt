// écrou

// use <reg_polygon.scad>
use <thread.scad>

module reg_polygon(n, r) circle(r=r, $fn=n);

module body(r=3, h=1) {
    rd = r/10;
    // rd = 0;
    // p = rd:
    p = r/10;
    cz = (r*r+4*p*p)/(8*p);
    R = sqrt(r*r+((cz-p)*(cz-p)));
    // R = sqrt((3*r*r/4)+(cz*cz)); // (same result)
    intersection() {
      translate([0, 0, rd])
        minkowski() {
            $fn = 60;
            linear_extrude(height=h-2*rd, center=false) reg_polygon(n=6, r=r-rd);
            cylinder(r=rd, h=2*rd, center=true);
        }
      translate([0,0,h-cz]) sphere(R);
      translate([0,0,cz]) sphere(R);
    }
}

$fn=60;

module nut(r=3, h=2, thr=0.15, depth=0.15) {
    r_hole=r/2;
    h_eps_hole=thr;
    h_hole=h+2*h_eps_hole;

    difference()  {
        body(r=r, h=h);
        translate([0,0,-h_eps_hole])
            thread(r=r_hole, d=depth, h=h_hole, thr=thr);
    }
}

nut();
