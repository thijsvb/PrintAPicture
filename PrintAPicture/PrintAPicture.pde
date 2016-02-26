PImage img;
PShape s;
PrintWriter file;
int res = 10;
float[][] z;
float f;

void setup() {
  size(600, 600, P3D);
  stroke(0);
  fill(128);

  img = loadImage("input.jpg");
  z = new float[(img.width/res)+1][(img.height/res)+1];
  file = createWriter("thing.stl");

  makeShape();
}

void draw() {      
  background(0);
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI, PI));
  scale(f, f);
  translate(-img.width/2, -img.height/2);
  shape(s);
}

void mousePressed() {
  if (mouseButton == LEFT && res < img.width && res < img.height) {
    ++res;
    
    makeShape();
  } else if (mouseButton == RIGHT && res > 0) {
    --res;
    
    makeShape();
  }
}

void keyPressed(){
  if(key == 's' || key == 'S'){
    makeStl();
  }
}

void makeShape() {
    s = createShape();

  for (int x=0; x<img.width-img.width%res; x+=res) {
    for (int y=0; y<img.height-img.height%res; y+=res) {
      z[x/res][y/res] = map( brightness( img.pixels[ y*img.width + x ] ), 0, 255, 1, 11 );
    }
  }

  if (img.width >= img.height) {
    f = (float(width)-100)/float(img.width);
  } else if (img.height > img.width) {
    f = (float(height)-100)/float(img.height);
  }

  s.beginShape(TRIANGLES);
  //bottom
  s.vertex(0, 0, 0);
  s.vertex(img.width-img.width%res, 0, 0);
  s.vertex(0, img.height-img.height%res, 0);

  s.vertex(img.width-img.width%res, 0, 0);
  s.vertex(0, img.height-img.height%res, 0);
  s.vertex(img.width-img.width%res, img.height-img.height%res, 0);
  //sides
  for (int x=0; x<img.width-img.width%res; x+=res) {
    s.vertex(x, 0, 0);
    s.vertex(x+res, 0, 0);
    s.vertex(x, 0, z[x/res][0]);

    s.vertex(x+res, 0, 0);
    s.vertex(x, 0, z[x/res][0]);
    s.vertex(x+res, 0, z[x/res+1][0]);

    s.vertex(x, img.height-img.height%res, 0);
    s.vertex(x+res, img.height-img.height%res, 0);
    s.vertex(x, img.height-img.height%res, z[x/res][img.height/res-1]);

    s.vertex(x+res, img.height-img.height%res, 0);
    s.vertex(x, img.height-img.height%res, z[x/res][img.height/res-1]);
    s.vertex(x+res, img.height-img.height%res, z[(x+res)/res][img.height/res-1]);
  }
  for (int y=0; y<img.height-img.height%res; y+=res) {
    s.vertex(0, y, 0);
    s.vertex(0, y+res, 0);
    s.vertex(0, y, z[0][y/res]);

    s.vertex(0, y+res, 0);
    s.vertex(0, y, z[0][y/res]);
    s.vertex(0, y+res, z[0][(y+res)/res]);

    s.vertex(img.width-img.width%res, y, 0);
    s.vertex(img.width-img.width%res, y+res, 0);
    s.vertex(img.width-img.width%res, y, z[img.width/res-1][y/res]);

    s.vertex(img.width-img.width%res, y+res, 0);
    s.vertex(img.width-img.width%res, y, z[img.width/res-1][y/res]);
    s.vertex(img.width-img.width%res, y+res, z[img.width/res-1][(y+res)/res]);
  }
  //top
  for (int y=0; y<img.height-img.height%res; y+=res) {
    for (int x=0; x<img.width-img.width%res; x+=res) {
      s.vertex(x, y, z[x/res][y/res]);
      s.vertex(x+res, y, z[(x+res)/res][y/res]);
      s.vertex(x, y+res, z[x/res][(y+res)/res]);

      s.vertex(x+res, y, z[(x+res)/res][y/res]);
      s.vertex(x, y+res, z[x/res][(y+res)/res]);
      s.vertex(x+res, y+res, z[(x+res)/res][(y+res)/res]);
    }
  }
  s.endShape();
}

void makeStl() {
  file.println("solid thing");
  //bottom
  file.println("facet normal 0 0 0");
  file.println("outer loop");
  file.println("vertex 0 0 0");
  file.println("vertex " + img.width + " 0 0");
  file.println("vertex 0 " + img.height + " 0");
  file.println("endloop");
  file.println("endfacet");

  file.println("facet normal 0 0 0");
  file.println("outer loop");
  file.println("vertex " + img.width + " 0 0");
  file.println("vertex 0 " + img.height + " 0");
  file.println("vertex " + img.width + ' ' + img.height + " 0");
  file.println("endloop");
  file.println("endfacet");
  //sides
  for (int x=0; x<img.width-res; x+=res) {
    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex " + x + " 0 0");
    file.println("vertex " + x+res + " 0 0");
    file.println("vertex " + x + " 0 " + z[x/res][0]);
    file.println("endloop");
    file.println("endfacet");

    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex " + x+res + " 0 0");
    file.println("vertex " + x + " 0 " + z[x/res][0]);
    file.println("vertex " + x+res + " 0 " + z[(x+res)/res][0]);
    file.println("endloop");
    file.println("endfacet");

    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex" + x + img.height + " 0");
    file.println("vertex " + x+res + ' ' + img.height + " 0");
    file.println("vertex " + x + ' ' + img.height + ' ' + z[x/res][img.height/res-1]);
    file.println("endloop");
    file.println("endfacet");

    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex " + x+res + ' ' + img.height + " 0");
    file.println("vertex " + x + ' ' + img.height + ' ' + z[x/res][img.height/res-1]);
    file.println("vertex " + x+res + ' ' + img.height + ' ' + z[(x+res)/res][img.height/res-1]);
    file.println("endloop");
    file.println("endfacet");
  }
  for (int y=0; y<img.height-res; y+=res) {
    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex 0 " + y + " 0");
    file.println("vertex 0 " + y+res + " 0");
    file.println("vertex 0 " + y + ' ' + z[0][y/res]);
    file.println("endloop");
    file.println("endfacet");

    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex 0 " + y+res + " 0");
    file.println("vertex 0 " + y + ' ' + z[0][y/res]);
    file.println("vertex 0 " + y+res + ' ' + z[0][(y+res)/res]);
    file.println("endloop");
    file.println("endfacet");

    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex " + img.width + ' ' + y + " 0");
    file.println("vertex " + img.width + ' ' + y+res + " 0");
    file.println("vertex " + img.width + ' ' + y + ' ' + z[img.width/res-1][y/res]);
    file.println("endloop");
    file.println("endfacet");

    file.println("facet normal 0 0 0");
    file.println("outer loop");
    file.println("vertex " + img.width + ' ' + y+res + " 0");
    file.println("vertex " + img.width + ' ' +  y + ' ' + z[img.width/res-1][y/res]);
    file.println("vertex " + img.width + ' ' + y+res + ' ' + z[img.width/res-1][(y+res)/res]);
    file.println("endloop");
    file.println("endfacet");
  }
  //top
  for (int y=0; y<img.height-res; y+=res) {
    for (int x=0; x<img.width-res; x+=res) {
      file.println("facet normal 0 0 0");
      file.println("outer loop");
      file.println("vertex " + x + ' ' + y + ' ' + z[x/res][y/res]);
      file.println("vertex " + x+res + ' ' + y + ' ' + z[(x+res)/res][y/res]);
      file.println("vertex " + x + ' ' + y+res + ' ' + z[x/res][(y+res)/res]);
      file.println("endloop");
      file.println("endfacet");

      file.println("facet normal 0 0 0");
      file.println("outer loop");
      file.println("vertex " + x+res + ' ' + y + ' ' + z[(x+res)/res][y/res]);
      file.println("vertex " + x + ' ' + y+res + ' ' + z[x/res][(y+res)/res]);
      file.println("vertex " + x+res + ' ' + y+res + ' ' + z[(x+res)/res][(y+res)/res]);
      file.println("endloop");
      file.println("endfacet");
    }
  }
  file.println("endsolid");
  file.flush();
  file.close();
}