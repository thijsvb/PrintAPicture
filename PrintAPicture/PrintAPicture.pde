/*

 PrintAPicture
 (c) Thijs van Beers, 2016
 GNU GPL 3
 https://github.com/thijsvb/PrintAPicture
 
 */

PImage img;                  //image to turn in to a stl file
PShape s;                    //visual render of what will become the stl file
PrintWriter file;            //stl file to write to
int res = 10;                //resolution in pixels/vertex
int var = 2;                 //variable to use: 0 for hue, 1 for saturation, 2 for brightness, 3 for red, 4 for green, 5 for blue
float scale = 1.00;          //scale factor
float max = 11;              //maximum z-height
boolean inverted = false;    //invert for the z-axis
float[][] z;                 //z height of all the points
float f;                     //factor to scale the render (so it fits on the screen)
float rotX, rotY;            //rotation of the model

void setup() {
  size(600, 600, P3D);
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial Bold", 12);
  textFont(font);

  makeShape();
}

void draw() {  
  PGraphics g = createGraphics(width, height, P3D);    //Putting the 3D render in a graphic is the best way I know right now to overlay a GUI layer
  g.beginDraw();
  g.background(0);
  g.translate(width/2, height/2);
  if (mousePressed && mouseButton == RIGHT) {          //Rotate the model when the right mouse button is pressed
    rotX = map(mouseY, 0, height, PI, -PI);
    rotY = map(mouseX, 0, width, -PI, PI);
  }
  g.rotateX(rotX);
  g.rotateY(rotY);
  g.scale(f, f);
  g.translate(-img.width/2, -img.height/2);            //All this rotating and translating and scaling is to make the model fit on the screen, be centred and rotated
  g.shape(s);
  g.endDraw();
  image(g, 0, 0);                                      //Draw the model

  pushStyle();                                         //Start the GUI layer, draw all the buttons, text and latching highlights
  fill(192, 128);
  noStroke();
  rect(10, 10, 100, 480, 15);
  stroke(255);
  fill(255);
  for (int y=40; y!=460; y+=30) {
    line(10, y, 110, y);
  }
  line(60, 70, 60, 100);
  line(60, 160, 60, 190);
  line(60, 220, 60, 310);
  line(60, 370, 60, 400);
  text("resolution:", 60, 25);
  text(res + " pixels/vertex", 60, 55);
  text('+', 35, 85); 
  text('-', 85, 85);
  text("max z-height:", 60, 115);
  text(int(max) + " mm", 60, 145);
  text("+", 35, 175); 
  text('-', 85, 175);
  text("inverse z", 60, 205);
  text("H", 35, 235); 
  text("R", 85, 235);
  text("S", 35, 265); 
  text("G", 85, 265);
  text("B", 35, 295); 
  text("B", 85, 295);
  text("scale:", 60, 325);
  text(nf(scale, 1, 2), 60, 355);
  text("+", 35, 385); 
  text('-', 85, 385);
  text(int(img.width) +"x"+ int(img.height) +"mm", 60, 415);
  text("ASCII STL", 60, 445);
  text("save", 60, 475);
  noStroke();
  fill(255, 128);
  switch(var) {
  case 0:
    rect(10, 220, 50, 30);
    break;

  case 1:
    rect(10, 250, 50, 30);
    break;

  case 2:
    rect(10, 280, 50, 30);
    break;

  case 3:
    rect(60, 220, 50, 30);
    break;

  case 4:
    rect(60, 250, 50, 30);
    break;

  case 5:
    rect(60, 280, 50, 30);
    break;
  }
  if (inverted) {
    rect(10, 190, 100, 30);
  }
  rect(10, 430, 100, 30);
  popStyle();
}

void mousePressed() {
  if (mouseButton == LEFT) {      //Check what button is pressed
    pushStyle();
    noStroke();
    fill(255, 128);
    //resolution
    if (mouseX >= 10 && mouseX <= 60 && mouseY >= 70 && mouseY <= 100 && res < img.width && res < img.height) {
      ++res;
      rect(10, 70, 50, 30);
      makeShape();
    } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 70 && mouseY <= 100 && res > 0) {
      --res;
      rect(60, 70, 50, 30);
      makeShape();
    } 
    //max z-height
    else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 160 && mouseY <= 190 && max < 255) {
      ++max;
      rect(10, 160, 50, 30);
      makeShape();
    } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 160 && mouseY <= 190 && max > 2) {
      --max;
      rect(60, 160, 50, 30);
      makeShape();
    } 
    //invert z-axis
    else if (mouseX >= 10 && mouseX <= 110 && mouseY >= 190 && mouseY <= 220) {
      inverted = !inverted;
      makeShape();
    }
    //variable
    else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 220 && mouseY <= 250) {
      var = 0;
      makeShape();
    } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 220 && mouseY <= 250) {
      var = 3;
      makeShape();
    } else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 250 && mouseY <= 280) {
      var = 1;
      makeShape();
    } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 250 && mouseY <= 280) {
      var = 4;
      makeShape();
    } else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 280 && mouseY <= 310) {
      var = 2;
      makeShape();
    } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 280 && mouseY <= 310) {
      var = 5;
      makeShape();
    } 
    //scale
    else if (mouseX >= 10 && mouseX <= 60 && mouseY >= 370 && mouseY <= 400 && scale < 1.95) {
      scale += 0.05;
      rect(10, 370, 50, 30);
      makeShape();
    } else if (mouseX >= 60 && mouseX <= 110 && mouseY >= 370 && mouseY <= 400 && scale > 0.05) {
      scale -= 0.05;
      rect(60, 370, 50, 30);
      makeShape();
    } 
    //save
    else if (mouseX >= 10 && mouseX <= 110 && mouseY >= 460 && mouseY <= 490) {
      rect(10, 460, 100, 30, 0, 0, 15, 15);
      makeStl();
    }    
    popStyle();
  }
}

void makeShape() {
  stroke(0);
  fill(128);
  img = loadImage("input.jpg");                                //Reload the image everytime makeShape is called to prevent scaling an already scaled image
  img.resize(int(scale*img.width), int(scale*img.height));
  s = createShape();
  z = new float[(img.width/res)+1][(img.height/res)+1];
  float a, b;
  if (inverted) {                                              //Swap the scale if the z-axis has to be inverted
    a = max;
    b = 1;
  } else {
    a = 1;
    b = max;
  }

  for (int x=0; x<img.width-img.width%res; x+=res) {
    for (int y=0; y<img.height-img.height%res; y+=res) {
      color pixel = img.pixels[ y*img.width + x ];
      float value;
      switch(var) {                                             //Use the chosen variable
      case 0:
        value = hue(pixel);
        break;

      case 1:
        value = saturation(pixel);
        break;

      case 2:
        value = brightness(pixel);
        break;

      case 3:
        value = red(pixel);
        break;

      case 4:
        value = green(pixel);
        break;

      case 5:
        value = blue(pixel);
        break;

      default:
        value = 0;
        break;
      }      
      z[x/res][y/res] = map( value, 0, 255, a, b );            //Set the z height for every point
    }
  }

  if (img.width >= img.height) {                               //Set the scale factor for the model
    f = (float(width)-100)/float(img.width);
  } else if (img.height > img.width) {
    f = (float(height)-100)/float(img.height);
  }

  s.beginShape(TRIANGLES);                                     //Begin drawing the shape using triangles, because that's easy to transfer to a STL
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
  file = createWriter("thing.stl");                    //Make the STL file

  file.println("solid thing");

  for (int i=0; i!=s.getVertexCount(); i+=3) {         //Write all the triangles using verteces from the shape
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