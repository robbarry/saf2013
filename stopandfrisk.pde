import java.io.File;
BufferedReader reader;
PShape world;

float leftExt = 845086.385583333;
float rightExt = 1094305.13558333;
float topExt = 276731.647633334;
float bottomExt = 118919.147633334;

int lines_at_once = 1000;

int alpha = 40;

void setup() {
  reader = createReader("saf.tsv");
  background(255);
  size(1200, 700);
  shapeMode(CORNER);
  world = loadShape("img/nypp.svg");
  shape(world, 0, 0, width, height);
}

void draw() {
  String line;

  // Add some fade
  fadewindow(255, 20);

  for(int i = 0; i < lines_at_once; i++) {
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    if (line != null) {
      line = line.replace('"', ' ').trim();
      String[] pieces = split(line, TAB);

      String race = pieces[5].trim();
      float xcord = int(pieces[7].trim());
      float ycord = int(pieces[8].trim());

      if (xcord > 1 && ycord > 1) {
        float x = (xcord - leftExt) / (rightExt - leftExt) * width;
        float y = height - ((ycord - bottomExt) / (topExt - bottomExt) * height);
        if (race.equals("B") || race.equals("P")) {
          fill(255, 0, 0, alpha);
          stroke(255, 0, 0, alpha);
        } else if (race.equals("Q")) {
          fill(0, 0, 255, alpha);
          stroke(0, 0, 255, alpha);
        } else if (race.equals("W")) {
          fill(0, 255, 0, alpha);
          stroke(0, 255, 0, alpha);
        } else {
          fill(0, 0, 0, alpha);
          stroke(0, 0, 0, alpha);
        }
        ellipse(x, y, 2, 2);
      }
    }
  }
}

// Clear old points
void fadewindow(int baseclr, int faderate) {
    stroke(baseclr,baseclr,baseclr,faderate);
    fill(baseclr,baseclr,baseclr,faderate);
    rect(0,0,width,height);
    shape(world, 0, 0, width, height);
}
