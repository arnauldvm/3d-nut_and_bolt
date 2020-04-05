module thread(r=0.5, d=0.1, h=1, thr=1/6) {
    //$fn=180;
    loop_count=h/thr;

    function section_vertices(a=0) = [
        [(r+d)*cos(a), (r+d)*sin(a), 0],
        // [r*cos(a), r*sin(a), -thr/2],
        // [r*cos(a), r*sin(a), thr/2]
        // extending further to guarantee overlap with cylinder
        [(r-d)*cos(a), (r-d)*sin(a), -thr],
        [(r-d)*cos(a), (r-d)*sin(a), thr]
    ];

    module section(a) {
        v = section_vertices();
        // vv = section_vertices(a);
        vv = section_vertices(a*1.1);
        Faces = [
            [0,1,2],   // section
            [3,5,4],   // next section
            [0,2,5,3], // other lateral
            [0,3,4,1], // one lateral
            [1,4,5,2]  // base
        ]; // ! make sure all face are oriented in the same direction (all vertices clockwise (or all anti-))
        polyhedron(points = concat(v, vv), faces=Faces);
    }
    // section(360/$fn);

    module section_i(i) {
      ang=i*360/$fn;
      hh=thr*i/$fn;
      translate([0,0,hh])
        rotate(a=ang, v=[0,0,1])
          section(360/$fn);
    }

    module helico() {
        union() {
        for (i=[0:$fn*loop_count]) {
            section_i(i);
        }
        }
    }

    union() {
        cylinder(r=r, h=h);
        helico();
    }

}

thread();
