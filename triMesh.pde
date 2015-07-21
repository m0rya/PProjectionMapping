class triMesh {

  PVector[] pos = new PVector[3];
  color col;
  int[] check = new int[3];

  triMesh(PVector[] _pos, color _col) {
    pos = _pos;
    col = _col;
  }

  triMesh(PVector a, PVector b, PVector c, color _col) {
    pos[0] = a;
    pos[1] = b;
    pos[2] = c;
    col = _col;
  }

  triMesh(int[] _pos, color _col, int a) {
    pos[0] = new PVector(_pos[0], _pos[1]);
    pos[1] = new PVector(_pos[2], _pos[3]);
    pos[2] = new PVector(_pos[4], _pos[5]);
    col = _col;

    loadColorData();
  }


  triMesh(int[] _check, color _col) {
    check = _check;
    col = _col;
  }


  void setColor(color _col) {
    col = _col;
  }

  void setPos(PVector[] tmp) {
    for (int i=0; i<3; i++) pos[i] = tmp[check[i]];
  }
  void drawMesh() {

    fill(col);
    noStroke();

    beginShape();
    for (int i=0; i<3; i++) vertex(pos[i].x, pos[i].y);
    endShape(CLOSE);
  }

  void changingColor() {
    float r = red(col) +int(random(-10, 10));
    float g = green(col) + int(random(-10, 10));
    float b = blue(col) + int(random(-10, 10));

    col = color(r, g, b);
  }
  
  void changeRetroColor(){
    int rndm = int(random(24));
    col = retroColor[rndm];
  }



  PVector accCol;
  int speed=60;
  int turnCount = speed;

  void turnToColor() {
    if (turnCount == speed) {
      setColorAcc();
      turnCount = 0;
    }

    float r = red(col) + accCol.x;
    float g = green(col) + accCol.y;
    float b = blue(col) + accCol.z;

    col = color(r, g, b, 255);
    turnCount ++;
  }


  int setAlpha;
  int alpha = 50;
  int accAlpha = 1;

  void turnToTurn() {
    if (alpha == 50) {
      setAlpha = int(random(200, 300));
      col = retroColor[int(random(24))];
      accAlpha = 1;
    }

    float r = red(col);
    float g = green(col);
    float b = blue(col);
    col = color(r, g, b, alpha);

    alpha += accAlpha;

    if (alpha == setAlpha) {
      accAlpha = -1;
    }
  }
  

  
  void triInTri(float rate, color triColor){
    PVector center = new PVector();
    center.x = (pos[0].x + pos[1].x + pos[2].x)/3;
    center.y = (pos[0].y + pos[1].y + pos[2].y)/3;
    
    
    PVector[] toCnt = new PVector[3];
    for(int i=0; i<3; i++){
      toCnt[i] = PVector.sub(center, pos[i]);
      toCnt[i].mult(rate);
      toCnt[i].add(pos[i]);
    }
    
   fill(triColor);
   //fill(col);
    noStroke();
    beginShape();
    for(int i=0; i<3; i++) vertex(toCnt[i].x, toCnt[i].y);
    endShape(CLOSE);
    
  }
  
  void triInTri(float rate){
    PVector center = new PVector();
    center.x = (pos[0].x + pos[1].x + pos[2].x)/3;
    center.y = (pos[0].y + pos[1].y + pos[2].y)/3;
    
    
    PVector[] toCnt = new PVector[3];
    for(int i=0; i<3; i++){
      toCnt[i] = PVector.sub(center, pos[i]);
      toCnt[i].mult(rate);
      toCnt[i].add(pos[i]);
    }
    
   // fill(triColor);
   fill(col);
    noStroke();
    beginShape();
    for(int i=0; i<3; i++) vertex(toCnt[i].x, toCnt[i].y);
    endShape(CLOSE);
    
  }



  void setColorAcc() {
    //color rndmColor = color(int(random(255)), int(random(255)), int(random(255)));
    int rndm = int(random(24));
    color rndmColor = retroColor[rndm];

    accCol = new PVector((red(rndmColor) - red(col))/speed, (green(rndmColor) - green(col))/speed, (blue(rndmColor) - blue(col))/speed);
  }



  color[] retroColor;

  void loadColorData() {
    String[] data = loadStrings("colorData.txt");

    retroColor = new color[data.length];

    for (int i=0; i<data.length; i++) {
      String[] tmp = data[i].split(",");
      retroColor[i] = color(int(tmp[0]), int(tmp[1]), int(tmp[2]));
    }

    println("color loaded");
  }
}

