member_width = 1.5;
member_height = 3.5;

module member(dx, dy, dz) {
	r = 0.25;
	minkowski() {
		cube([dx-r, dy-r, dz-r]);
		sphere(r);
	};
};

module wall2x4(dx, dy, size) {
	for (i = [0:size-1]) {
		translate([0, 0, member_height * i]) member(dx, dy, member_height);
	};
};

module floor2x4(dx, dz, size) {
	for (i = [0:size-1]) {
		translate([0, member_height * i, 0]) member(dx, member_height, dz);
	};
};

big_wall_size = 6*12 + 6;
small_wall_size = 9 * member_height + 2 * member_width;
height = 24.5;

// big walls
translate([member_width, 0, 0]) {
	wall2x4(big_wall_size, member_width, 7);
};
translate([member_width, small_wall_size - member_width, 0]) {
	wall2x4(big_wall_size, member_width, 7);
};

// small walls
translate([0, 0, 0]) {
	wall2x4(member_width, small_wall_size, 7);
};
translate([big_wall_size + member_width, 0, 0]) {
	wall2x4(member_width, small_wall_size, 7);
};

// floor
translate([member_width, member_width, member_height]) {
	floor2x4(big_wall_size, member_width, 9);
};

// ribs
translate([0, -member_width, 0]) {
	member(member_height, member_width, height);
};
translate([big_wall_size/2 + member_width - member_height/2, -member_width, 0]) {
	member(member_height, member_width, height);
};
translate([big_wall_size + 2 * member_width - member_height, -member_width, 0]) {
	member(member_height, member_width, height);
};
translate([0, small_wall_size, 0]) {
	member(member_height, member_width, height);
};
translate([big_wall_size/2 + member_width - member_height/2, small_wall_size, 0]) {
	member(member_height, member_width, height);
};
translate([big_wall_size + 2 * member_width - member_height, small_wall_size, 0]) {
	member(member_height, member_width, height);
};

// floor ribs
for (i = [1:4]) {
	translate([(2 * member_width + big_wall_size) / 5 * i - member_width / 2, member_width, 0]) {
		member(member_width, small_wall_size - member_width * 2, member_height);
	};
};
