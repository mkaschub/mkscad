
module tx(x) { translate([x,0,0]) children(); }
module ty(y) { translate([0,y,0]) children(); }
module tz(z) { translate([0,0,z]) children(); }

module rotx(a=90) { rotate([a,0,0]) children(); }
module roty(a=90) { rotate([0,a,0]) children(); }
module rotz(a=90) { rotate([0,0,a]) children(); }

module mx() { mirror([1,0,0]) children(); }
module my() { mirror([0,1,0]) children(); }
module mz() { mirror([0,0,1]) children(); }

module cmx() { children(); mirror([1,0,0]) children(); }
module cmy() { children(); mirror([0,1,0]) children(); }
module cmz() { children(); mirror([0,0,1]) children(); }

module ctx(a) { for (x=a) tx(x) children(); }
module cty(a) { for (x=a) ty(x) children(); }
module ctz(a) { for (x=a) tz(x) children(); }

module t(x=0, y=0, z=0) { translate([x,y,z]) children(); }

module PART(x=0, y=0, z=0, name="") { translate([x,y,z]) children(); }

module hex(d=1, d2=false, r=false, r2=false)
{
  dd = d2 ? d2*2/sqrt(3) : (r ? 2*r: (r2 ? r2*4/sqrt(3) : d));
  rotz(30) circle(d=dd, $fn=6);
}

module cube_round(dim, r=0, center=false) { le(dim.z) offset(r) offset(-r) square([dim.x, dim.y]); }

module diff() 
{  
  if($children >1) {
    difference() { children(0); children([1:$children-1]); }
  } else {
    children();
  }
} 
  
module inter() { intersection_for(n=[0:$children-1]) children(n); } 

module le(h, center=false, convexity=2, scale=1, twist=0, slices=undef) { linear_extrude(height=h, convexity=convexity, scale=scale, center=center, twist=twist, slices=slices)children(); }

module re(angle = 360, r = 0) { tx(-r) rotate_extrude(angle = angle) tx(r) children(); }

