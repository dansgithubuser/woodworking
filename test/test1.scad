cube([1,2,3]);
translate([5, 0, 0]) {
    cube([4,5,6]);
}
for(i = [0:2:10]) {
    translate([0, i+4, 0]) {
        cube([1, 1, 1]);
    }
}