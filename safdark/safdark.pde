import java.io.File;

BufferedReader reader;
int i = 0;
int faderate = 10;
boolean flag = false;
String[] lines;
int stamp = 0;
int[] whites = new int[10000];
int[] blacks = new int[10000];
int[] hispanics = new int[10000];
int[] others = new int[10000];
int[] points_x = new int[10000];
int[] points_y = new int[10000];
int[] points_precinct = new int[10000];
int[] clrs = new int[10000];
int white;
int black;
int hispanic;
int other;
int stack = 0;
int fr = 12;
int[][] precinct_pop = new int[200][5];
float leftExt = 845086.385583333;
float rightExt = 1094305.13558333;
float topExt = 276731.647633334;
float bottomExt = 118919.147633334;

PShape world;

void setup() {

  size(840,600);
  stroke(0);
  fill(0);
  //rect(0,0,width,height);
  stroke(255);
  lines = loadStrings("../data/saf.tsv");
  frameRate(fr);
  smooth();
  loadMap();
  background(0);
  shapeMode(CORNER);
}

void draw() {

  shapeMode(CORNER);
  shape(world, 0, 0, width, height);
  String date = "";
  String time = "";
  int h = 0;
  int sstamp = 0;
  boolean go = true;
  int clr = 0;
  stroke(clr,clr,clr,faderate);
  fill(clr,clr,clr,faderate);
  rect(0,0,width,height);
  stroke(255,255,255,100);
  fill(255,255,255,100);
  white = 0;
  black = 0;
  hispanic = 0;
  other = 0;
  int k = 0;
  if (i >= lines.length - 1000) {
    noLoop();
  }

  while(go) {
    String line = lines[i];
    line = line.replace('"', ' ').trim();
    String[] pieces = split(line, TAB);

    float x = int(pieces[7].trim());
    float y = int(pieces[8].trim());

    x = (x-leftExt) / (rightExt - leftExt) * width;
    y = height-((y-bottomExt) / (topExt - bottomExt) * height);
    date = nf(int(pieces[2].trim()), 8); // 8-digit padded date
    time = nf(int(pieces[3].trim()), 4); // 4-digit padding time

    int min = int(time.substring(2));
    int hr = int(time.substring(0,2));
    int mon = int(date.substring(0,2));
    int day = int(date.substring(2,4));
    int year = int(date.substring(4));

    stamp = hr*60 + min;
    if (sstamp == 0) {
      sstamp = stamp;
    } else {
      int dif = stamp - sstamp;
      if (dif < 0) dif = dif + (24*60);
      if (dif >= 30) go = false;
      //if (k > 30) go = false;
    }

    String race = pieces[5].trim();
    if ((race.equals("B")) || (race.equals("P"))) {
      stroke(255,0,0,100);
      clrs[k] = 1;
      black++;
    } else if (race.equals("W")) {
      stroke(0,0,255,100);
      clrs[k] = 3;
      white++;
    } else if (race.equals("Q")) {
      stroke(0,255,0,100);
      clrs[k] = 2;
      hispanic++;
    } else {
      stroke(255,255,0,100);
      clrs[k] = 4;
      other++;
    }

    points_x[k] = int(x);
    points_y[k] = int(y);
    points_precinct[k] = int(pieces[1].trim());
    k++;
    i++;
  }

  loadPixels();
  int rad = 40;
  int clrstr = 255;

  for(int cc=0;cc<k;cc++) {
    int x = points_x[cc];
    int y = points_y[cc];
    if (x + y*width > width*height) continue;
    int[] clo = colorParts(pixels[int(x + y*width)]);
    rad = int(max(clo) / 150 * 50);
    if ((x >= rad) && (x < width-rad) && (y >= rad) && (y <= height-rad)) {
      for(int nx=-rad;nx<rad+1;nx++) {
        for(int ny=-rad;ny<rad+1;ny++) {
          int nnx = int(x) + nx;
          int nny = int(y) + ny;
          if (clrs[cc]-1>=0) {
            //float denom = pow((pow(nx,2)+pow(ny,2)+1), 1) * precinct_pop[points_precinct[cc]][clrs[cc]];
            float denom = pow((pow(nx,2)+pow(ny,2)+1), 1.5 );
            float addition = float(clrstr)/denom;
            float addition1 = addition;
            float addition2 = addition;
            float addition3 = addition;
            if (nnx + nny*width > width*height) continue;
            int[] cl = colorParts(pixels[nnx+nny*width]);
            if (clrs[cc] < 4) {
              int ourcl = cl[clrs[cc]-1];
              if (ourcl + addition > 255) addition = 255-ourcl;
            } else {
              if (clrs[cc] == 4) {
                int ourcl1 = cl[0];
                int ourcl2 = cl[1];
                int ourcl3 = cl[2];
                if (ourcl1 + addition1 > 255) addition1 = 255-ourcl1;
                if (ourcl2 + addition2 > 255) addition2 = 255-ourcl2;
                if (ourcl3 + addition3 > 255) addition3 = 255-ourcl3;
              }
            }
            if (clrs[cc] == 1) {
              pixels[nnx+nny*width] += color(addition, 0, 0);
            } else if (clrs[cc] == 2) {
              pixels[nnx+nny*width] += color(0, addition, 0);
            } else if (clrs[cc] == 3) {
              pixels[nnx+nny*width] += color(0, 0, addition);
            } else if (clrs[cc] == 4) {
              pixels[nnx+nny*width] += color(addition1,addition2,addition3);
            }
          }
        }
      }

    }
  }
  updatePixels();
  fill(0);
  stroke(0);
  int base = 330;
  rect(0,0,200,base);
  whites[stack] = white;
  blacks[stack] = black;
  hispanics[stack] = hispanic;
  others[stack] = other;
  stack++;
  int begin = stack - 24*7;
  if (begin < 0) begin = 0;
  for(int cnt = begin;cnt<=stack;cnt++) {
    stroke(255,255,255);
    line(25+(cnt-begin),base-1-whites[cnt]-hispanics[cnt]-blacks[cnt],25+(cnt-begin),base-hispanics[cnt]-blacks[cnt]-whites[cnt]-others[cnt]);
    stroke(0,0,255);
    line(25+(cnt-begin),base-1-hispanics[cnt]-blacks[cnt],25+(cnt-begin),base-hispanics[cnt]-blacks[cnt]-whites[cnt]);
    stroke(0,255,0);
    line(25+(cnt-begin),base-1-blacks[cnt],25+(cnt-begin),base-blacks[cnt]-hispanics[cnt]);
    stroke(255,0,0);
    line(25+(cnt-begin),(base-1),25+(cnt-begin),base-blacks[cnt]);
  }
  float grad = 155-155*abs(14*60 - float(stamp))/(14*60);
  color cl = color(100+grad, 100+grad, 100);
  fill(cl);
  text(date + " " + time, 10, 20);
  fill(0,0,255);
  text("white", 130, 20);
  fill(255,0,0);
  text("black", 180, 20);
  fill(0,255,0);
  text("hispanic", 230, 20);
  fill(255,255,255);
  text("other", 300, 20);
}

int[] colorParts(color spot) {
  int[] colors = new int[3];
  colors[0] = (spot >> 16) & 0xFF;
  colors[1] = (spot >> 8) & 0xFF;
  colors[2] = spot & 0xFF;
  return colors;
}

void keyPressed() {
  saveFrame(); 
}

void loadMap() {
    world = loadShape("../img/nypp.svg");
    shape(world, 0, 0, width, height);
}