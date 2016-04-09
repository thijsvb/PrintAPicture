size(500, 500);
for (int x=0; x!=width; ++x) {
  float a = sin(map(x, 0, width, 0, TWO_PI*4));
  for (int y=0; y!=height; ++y) {
    float b = cos(map(y, 0, height, 0, TWO_PI*4));
    float k = map(x+y, 0, width+height, 0, 40);
    stroke(constrain(map(a*b, -1, 1, 0, 255) + random(-k,k), 0, 255));
    point(x, y);
  }
}
save("input.jpg");
exit();