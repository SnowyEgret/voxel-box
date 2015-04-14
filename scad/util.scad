// Used by top ring to build its three solids

//chanfered_ring();
//chanfered_box();
//pipe(ir1=100, ir2=90, t=10, h=30, $fn=120);
//pipe(ir=100, t=10, h=30, $fn=120);
//chanfered_profile(c4=[2,3]);
//chanfered_cylinder(ir=40, h=40, taper_bottom=-5, c4=[2,2], $fn=120);
//cylinder(r=10,h=40);
//chanfered_cylinder(h=40, t=20, c3=[2,2], center=false, $fn=120);
//beveled_cube(size=[30,30,5], radius=5, chanfer=[1,1], $fn=120);

chanfer=1;
chanfer_angle=4;
bottom_chanfer_scale=4;
m=25.4;

//Used by chanfered_cylinder
module chanfered_profile(x=10, dx_top=0, dx_bottom=0, y=20, c1=[0,0], c2=[0,0], c3=[0,0], c4=[0,0]) {
  polygon(points=[
    [dx_bottom+0+c1[0],0],
    [dx_bottom+x-c2[0],0],
    [dx_bottom+x,c2[1]],
    [dx_top+x,y-c3[1]],
    [dx_top+x-c3[0],y],
    [dx_top+0+c4[0],y],
    [dx_top+0,y-c4[1]],
    [dx_bottom+0,c1[1]],
  ]);
}

module chanfered_cylinder(ir=0, taper_top=0, taper_bottom=0, t=10, h=20, c1=[0,0], c2=[0,0], c3=[0,0], c4=[0,0], center=false) {
  translate([0,0,center ? -h/2 : 0])
    rotate_extrude()
      translate([ir,0,0])
        chanfered_profile(x=t, dx_top=taper_top, dx_bottom=taper_bottom, y=h, c1=c1, c2=c2, c3=c3, c4=c4);
}

module profile(w, h, c=chanfer, a=chanfer_angle) {
  polygon(points=[
    [0,0],
    [w-bottom_chanfer_scale*c,0],
    [w,bottom_chanfer_scale*(c+a)],
    [w,h-c],
    [w-c,h],
    [0,h],
  ]);
}

module chanfered_ring(ir=0, w=10, h=20, c=chanfer) {
  rotate_extrude()
    translate([ir,0,0])
      profile(w=w, h=h, c=c);
}

module chanfered_box(l=30, w=10, h=20, c=chanfer) {
  linear_extrude(height=l) {
    profile(w=w/2, h=h, c=c);
    mirror([1,0,0])
    profile(w=w/2, h=h, c=c);
  }
}

//For now centered
//Duplicates hollow_cylinder
module pipe(ir, ir1, ir2, t, h) {
  difference() {
    cylinder(r=ir+t, r1=ir1+t, r2=ir2+t, h=h, center=true);
    cylinder(r=ir, r1=ir1, r2=ir2, h=h+.01, center=true);
  }
}


// Defaults to 6-32 1/2 inch
//First print of terminal cup: module screw_hole(r_shaft=1.8, l_shaft=.5*m, r_head=3.4, l_head=10) {
//TODO shaft radius wants to be small for diffencing holes in other part yet large for this part.
module screw_hole(r_shaft=1.8, l_shaft=.5*m, r_head=3.8, l_head=10) {
  cylinder(r=r_head, l_head);
  translate([0,0,-l_shaft])
    cylinder(r=r_shaft, l_shaft+.01);
}

// Move to basic geometry library
// Duplicates code in plumbing library
module hollow_cylinder(ir, t, h) {
  difference() {
    cylinder(r=ir+t, h=h, center=true);
    cylinder(r=ir, h=h+2, center=true);
  }
}

// Move to util library
module radial_section_of(d=1000, angle=90) {
  difference() {
    children(0);
    union() {
      rotate([0,0,90-angle/2]) translate([-d/2,0,0]) cube(size=[d,d,d], center=true);
      rotate([0,0,-90+angle/2]) translate([-d/2,0,0]) cube(size=[d,d,d], center=true);
    }
  }
}

module radial_array(n=4, r=0) {
  for(rz=[0:360/n:359]) {
    rotate([0,0,rz])
        translate([r,0,0])
            children(0);
  }
}

module prism(sides=4, height=10, r=20, corner_radius=5, c2=[0,0], c3=[0,0]) {
  translate([0,0,height/2])
    minkowski() {
      cylinder(
        r=r,
        h=.0001,
        center=true,
        $fn=sides
      );
     chanfered_cylinder(t=corner_radius, h=height, c2=c2, c3=c3, center=true); 
    }
}

