//box();
//color("yellow") dyeChanfered();
//color("blue") corner();
color("green") side();
//color("red") quarterSide();

voxel=10;
width=12;
tolerance=.1;

//For creating random pattern of holes
margin=3;
density=2;
rands = rands(0,10,(width*width));

module box() {
  color("blue") corner();
  color("red") side();
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
    for(x=[-(width/2)+margin:1:(width/2)-margin]) {
      for(y=[-(width/2)+margin:1:(width/2)-margin]) {
        if(rands[(x*(width-2*margin))+y] < density) {
          translate([x*voxel+voxel/2, y*voxel+voxel/2, 0]) dye();
        }
      }     
    }
  }
}

module quarterSide(size=width*voxel/2) {
  difference() {
    translate([-voxel/2,-voxel/2,-voxel/2]) cube([size, size, voxel]);
    translate([size-voxel, size-voxel, 0]) dye();
    translate([size-2*voxel, size-2*voxel, 0]) dye();
    for(x=[voxel:voxel:size]) {
      translate([size-x, size-voxel, 0]) dye();
    }    
    translate([size-voxel, -voxel, 0]) dye();
    
    rotate(-90,[0,0,1]) mirror([0,0,1])
      translate([-size+1.5*voxel-tolerance, size-1.5*voxel-tolerance, -voxel/2-tolerance]) chanfer();
  }
}

module dyeChanfered() {
  difference() {
    dye();
    translate([-voxel/2-tolerance,-voxel/2-tolerance,-voxel/2-tolerance]) chanfer();
   }
}

module dye() {
  cube([voxel+tolerance, voxel+tolerance, voxel+tolerance], center=true);
}

module chanfer(size=.7*voxel) {
  polyhedron(
    points=[[0,0,0], [size,0,0], [0,size,0], [0,0,size]],
    faces=[[0,3,1], [2,3,0], [0,1,2], [1,3,2]],
    convexity=2);
}


