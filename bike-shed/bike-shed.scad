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

module member(size, desc) {
  echo(desc);
  for (i = [0:2]) {
    feet = floor(size[i]);
    inches = (size[i] - feet) * 12;
    echo(str("\t", feet, "'", inches, "\","));
  }
  cube(size);
}

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
  member([roof_width, roof_depth, wall_thickness], "roof");
};

// back
translate([-wall_thickness, -wall_thickness, member_width]) {
  member([inner_width + 2 * wall_thickness, wall_thickness, back_inner_height - member_width], "back");
};

// left & right wall
roof_truncate() {
  union() {
    translate([inner_width, 0, member_width]) { // left
      member([wall_thickness, inner_depth, front_inner_height], "left wall");
    };
    translate([-wall_thickness, 0, member_width]) { // right
      member([wall_thickness, inner_depth, front_inner_height], "right wall");
    };
  };
};

// supports
module support(height, desc) {
  translate([0, 0, member_width]) {
    member([member_width, member_depth, height], desc);
  };
};

module support_pair(height, desc) {
  translate([0, 0, 0]) {
    support(height - member_width, str(desc, " right"));
  };
  translate([inner_width - member_width, 0, 0]) {
    support(height - member_width, str(desc, " left"));
  };
};

translate([0, 0, 0]) {
  support_pair(back_inner_height, "support - back");
};
translate([0, inner_depth - member_depth, 0]) {
  support_pair(front_inner_height, "support - front");
};

// door
translate([member_width, inner_depth - wall_thickness, member_width]) {
  rotate([0, 0, 45]) {
    member([inner_width - 2 * member_width, wall_thickness, front_inner_height - member_width], "door");
    translate([0, -member_width, 0.25]) {
      member([member_depth, member_width, 3.25], "door hinge screw bed");
    };
    translate([inner_width - 2 * member_width - member_depth, -member_width, 1.5]) {
      member([member_depth, member_width, 1], "door hasp screw bed");
    };
  };
};

// floor
translate([0, 0, member_width]) {
  member([inner_width, inner_depth, wall_thickness], "floor");
};
translate([0, 0, 0]) {
  member([inner_width, member_depth, member_width], "floor support");
};
translate([0, (inner_depth - member_depth) / 2, 0]) {
  member([inner_width, member_depth, member_width], "floor support");
};
translate([0, inner_depth - member_depth, 0]) {
  member([inner_width, member_depth, member_width], "floor support");
};
