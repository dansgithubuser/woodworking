front_inner_height = 4; // ft
back_inner_height = 3.5; // ft
inner_width = 2.5; // ft
inner_depth = 6; // ft
wall_thickness = 7/16/12; // ft

roof_overhang = 3/12;
roof_rise = front_inner_height - back_inner_height;
roof_width = inner_width + 2 * roof_overhang;
roof_depth = sqrt(pow(inner_depth, 2) + pow(roof_rise, 2)) + 2 * roof_overhang;
roof_angle = atan(roof_rise / inner_depth);

member_width = 1.5/12; // ft
member_depth = 3.5/12; // ft

// roof
module roof_transform() {
  translate([0, 0, back_inner_height]) {
    rotate([roof_angle, 0, 0]) {
      translate([-roof_overhang, -roof_overhang, 0]) {
        children();
      };
    };
  };
};

module roof_truncate() {
  difference() {
    children();
    roof_transform() {
      cube([roof_width + 1, roof_depth + 1, 5]);
    };
  };
};

roof_transform() {
  cube([roof_width, roof_depth, wall_thickness]);
};

// back
translate([-wall_thickness, -wall_thickness, 0]) {
  cube([inner_width + 2 * wall_thickness, wall_thickness, back_inner_height]);
};

// left & right wall
roof_truncate() {
  union() {
    translate([inner_width, 0, 0]) { // left
      cube([wall_thickness, inner_depth, front_inner_height]);
    };
    translate([-wall_thickness, 0, 0]) { // right
      cube([wall_thickness, inner_depth, front_inner_height]);
    };
  };
};

// supports
module support() {
  translate([0, 0, member_width]) {
    cube([member_width, member_depth, front_inner_height+1]);
  };
};

module support_pair() {
  union() {
    translate([0, 0, 0]) {
      support();
    };
    translate([inner_width - member_width, 0, 0]) {
      support();
    };
  };
};

roof_truncate() {
  union() {
    translate([0, 0, 0]) {
      support_pair();
    };
    translate([0, inner_depth - member_depth, 0]) {
      support_pair();
    };
  };
};

// door
translate([member_width, inner_depth - wall_thickness, member_width]) {
  rotate([0, 0, 45]) {
    cube([inner_width - 2 * member_width, wall_thickness, front_inner_height - member_width]);
  };
};

// floor
translate([0, 0, member_width]) {
  cube([inner_width, inner_depth, wall_thickness]);
};
translate([0, 0, 0]) {
  cube([inner_width, member_depth, member_width]);
};
translate([0, (inner_depth - member_depth) / 2, 0]) {
  cube([inner_width, member_depth, member_width]);
};
translate([0, inner_depth - member_depth, 0]) {
  cube([inner_width, member_depth, member_width]);
};
