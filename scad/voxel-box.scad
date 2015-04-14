include <util.scad>;

box();
//negative_corner();
//bottom();
//color("yellow") dyeChanfered();
//color("blue") corner();
//color("green") side();
//color("red") quarterSide();

voxel=10;
width=12;
//Printed first at .1
tol=.5;

//For creating random pattern of holes
margin=4;
density=2;
rands = rands(0,10,(width*width));

module box() {
  corners();
  radial_array(n=4)
    rotate([90,0,0])
      bottom();
  bottom();
  mirror([1,0,0])
    mirror([0,0,1])
      bottom();
 }

module corners() {
  mirror([0,0,1])
  radial_array(n=4)
    negative_corner();
  radial_array(n=4)
    negative_corner();
}

module negative_corner() {
  d=(width-1)/2*voxel;
  color("red") translate([-d,-d,-d]) corner();
}

module bottom() {
  d=(width-1)/2*voxel;
  color("blue") translate([0,0,-d]) side();
}

module corner(size=2*voxel) {
  difference() {
    translate([-voxel/2,-voxel/2,-voxel/2]) cube([size,size,size]);
    translate([voxel,0,0]) rotate(-90, [0,0,1]) mirror([0,0,1]) dyeChanfered();
    translate([0,voxel,0]) rotate(90, [0,0,1]) mirror([0,0,1]) dyeChanfered();
    translate([0,0,voxel]) rotate(180, [0,0,1]) dyeChanfered();
  }
}

module side() {
  difference() {
    union() {
      for(r=[0:90:270]) {
        rotate(r, [0, 0, voxel]) translate([voxel/2, voxel/2, 0]) quarterSide();
      }
    }
    //translate([voxel/2, voxel/2, 0]) dye();
    
//    for(x=[-(width/2)+margin:1:(width/2)-margin]) {
//      for(y=[-(width/2)+margin:1:(width/2)-margin]) {
//        if(rands[(x*(width-2*margin))+y] < density) {
//          translate([x*voxel+voxel/2, y*voxel+voxel/2, 0]) dye();
//        }
//      }     
//    }
  }
}

module quarterSide(size=width*voxel/2) {
  difference() {
    translate([-voxel/2,-voxel/2,-voxel/2])
      cube([size, size, voxel-tol/2]);
//    translate([size-voxel, size-voxel, 0])
//      dye();
    //Remove row on edge
    for(x=[voxel:voxel:size]) {
      translate([size-x, size-voxel, 0]) dye();
    }    
    //Remove notch. Must be done twice offet by half the tol
    translate([size-2*voxel, size-2*voxel, 0])
      dye();
    translate([size-2*voxel-tol/2, size-2*voxel, 0])
      dye();
    
    //Small notch on edge
    translate([size-voxel, -voxel, 0])
      dye();
    
    //Chanfer corner
    rotate(-90,[0,0,1])
      mirror([0,0,1])
        translate([
          -size+1.5*voxel-tol,
          size-1.5*voxel-tol,
          -voxel/2-tol])
            chanfer();
  }
}

module dyeChanfered() {
  difference() {
    dye();
    translate([-voxel/2-2*tol,-voxel/2-tol,-voxel/2-2*tol]) chanfer();
  }
}

module dye() {
  cube([voxel+tol, voxel+tol, voxel+tol], center=true);
}

module chanfer(size=.7*voxel) {
  polyhedron(
    points=[[0,0,0], [size,0,0], [0,size,0], [0,0,size]],
    faces=[[0,3,1], [2,3,0], [0,1,2], [1,3,2]],
    convexity=2);
}

//module rz(angle) {
//  rotate([0,0,angle])
//    children(0);
//}


