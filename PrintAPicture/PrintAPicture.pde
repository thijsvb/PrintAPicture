PImage img;
PShape s;
PrintWriter file;
int res = 10;
float max = 11;
boolean inverted = false;
float[][] z;
float f;

void setup() {
  size(600, 600, P3D);
  stroke(0);
  fill(128);
  textAlign(CENTER, CENTER);

  img = loadImage("input.jpg");
  z = new float[(img.width/res)+1][(img.height/res)+1];
  file = createWriter("thing.stl");

  makeShape();
}

void draw() {  
  PGraphics g = createGraphics(width, height, P3D);
  g.beginDraw();
  g.background(0);
  g.translate(width/2, height/2);
  g.rotateX(map(mouseY, 0, height, PI, -PI));
  g.rotateY(map(mouseX, 0, width, -PI, PI));
  g.scale(f, f);
  g.translate(-img.width/2, -img.height/2);
  g.shape(s);
  g.endDraw();
  image(g, 0, 0);

  pushStyle();
  fill(192, 128);
  noStroke();
  rect(10, 10, 100, 300, 15);
  stroke(255);
  fill(255);
  for (int y=40; y!=310; y+=30) {
    line(10, y, 110, y);
  }
  line(60, 70, 60, 100);
  line(60, 160, 60, 190);
  line(60, 220, 60, 310);
  text("res:", 60, 25);
  text(res + " pixels/vertex", 60, 55);
  text('+', 35, 85); 
  text('-', 85, 85);
  text("max z-height:", 60, 115);
  text(max + " mm", 60, 145);
  text("+", 35, 175); 
  text('-', 85, 175);
  text("inverse z", 60, 205);
  text("H", 35, 235); 
  text("R", 85, 235);
  text("S", 35, 265); 
  text("G", 85, 265);
  text("B", 35, 295); 
  text("B", 85, 295);
  noStroke();
  fill(255, 128);
  rect(10, 280, 50, 30, 0, 0, 0, 15);
  if (inverted) {
    rect(10, 190, 100, 30);
    popStyle();
  }

  void mousePressed() {
    if (mouseButton == LEFT) {
      pushStyle();
      noStroke();
      fill(255, 128);
      //resolution
      if (mouseX >= 10 && mouseX <= 60 && mouseY >= 70 && mouseY <= 100 && res < img.width && res < img.height) {
        ++res;
        rect(10, 80, 50, 30);
        makeShape();
      } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 70 && mouseY <= 100 && res > 0) {
        --res;
        rect(60, 80, 50, 30);
        makeShape();
      } 
      //max z-height
      else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 160 && mouseY <= 190 && max < 255) {
        ++max;
        rect(10, 170, 50, 30);
        makeShape();
      } else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 160 && mouseY <= 190 && max > 2) {
        --max;
        rect(60, 170, 50, 30);
        makeShape();
      } 
      //invert z-axis
      else if (mouseX >= 10 && mouseX <= 110 && mouseY >= 190 && mouseY <= 220) {
        inverted = !inverted;
      }
      popStyle();
    }
  }

  void keyPressed() {
    if (key == 's' || key == 'S') {
      makeStl();
    }
  }

  void makeShape() {
    s = createShape();
    z = new float[(img.width/res)+1][(img.height/res)+1];
    float a, b;
    if (inverted) {
      a = max;
      b = 1;
    } else {
      a = 1;
      b = max;
    }

    for (int x=0; x<img.width-img.width%res; x+=res) {
      for (int y=0; y<img.height-img.height%res; y+=res) {
        z[x/res][y/res] = map( brightness( img.pixels[ y*img.width + x ] ), 0, 255, a, b );
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

    for (int i=0; i!=s.getVertexCount(); i+=3) {
      file.println("facet normal 0 0 0");
      file.println("outer loop");
      file.println("vertex " + s.getVertex(i).x + ' ' + s.getVertex(i).y + ' ' + s.getVertex(i).z);
      file.println("vertex " + s.getVertex(i+1).x + ' ' + s.getVertex(i+1).y + ' ' + s.getVertex(i+1).z);
      file.println("vertex " + s.getVertex(i+2).x + ' ' + s.getVertex(i+2).y + ' ' + s.getVertex(i+2).z);
      file.println("endloop");
      file.println("endfacet");
    }

    file.println("endsolid");
    file.flush();
    file.close();
  }