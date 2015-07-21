import ddf.minim.*;

//music
Minim minim;
AudioPlayer player;
int waveH = 100;

//===

final int vecNum = 10;

PVector[] vec = new PVector[10];
triMesh[] mesh = new triMesh[10];

int meshCount = 0;
int vecCount = 0;

boolean setPnt = true;
boolean setMesh = false;
boolean dragPnt = false;
boolean showPoint = true;

boolean write = true
;
boolean loaded = false;

PrintWriter writer;

//ArrayList<triMesh> mesh = new ArrayList<triMesh>();

void setup() {
  size(600, 600);
  minim = new Minim(this);
  player = minim.loadFile("hbhb.mp3");
  player.play();
}

void draw() {
  background(255);
  fill(0);
  if (write) {
    if (showPoint) {
      for (int i=0; i<vecCount; i++) {
        ellipse(vec[i].x, vec[i].y, 10, 10);
      }
    }

    for (int i=0; i<meshCount; i++) {
      mesh[i].setPos(vec);
      mesh[i].drawMesh();
    }
  }



  if (loaded) {
    for (triMesh Mesh : loadMesh) {
      // Mesh.turnToColor();
      //Mesh.turnToTurn();
      /*
      for (int i=0; i<player.left.size ()-1; i++) {
       if (player.left.get(i)*waveH > 55) {
       int rndm = int(random(5));
       if(rndm > 3) kaidanKirakira(Mesh);
       
       
       } else if(player.left.get(i)*waveH>50){
       int rndm = int(random(5));
       if(rndm > 3) Mesh.drawMesh();
       }
       */
    
    rendou2(Mesh);
      //==variation==//
      //kaidan(Mesh);
      //zoomInOut(Mesh);
      //kaidanKirakira(Mesh);
      //rendou1(Mesh);
    }
  }
}


//====variation Graphics
void rendou2(triMesh Mesh){
  float ave=0;
  for(int i=0; i<player.left.size()-1; i++){
    ave += player.left.get(i);
  }
  ave /= player.left.size();
  ave = abs(ave);
  ave*=10;
  
  
  //println(ave);
  constrain(ave,0.0,1.0);
  if(ave > 0.5){
    Mesh.changeRetroColor();
  }
    
  Mesh.triInTri(ave);
  
  
  
  
}
void rendou1(triMesh Mesh){
  float max=0;
       for(int i=0; i<player.left.size()-1; i++){
         if(max < player.left.get(i)*waveH) max = player.left.get(i)*waveH;
       }
       //println(max);
       if(max > 80){
         int rndm = int(random(5));
         if(rndm > 3) kaidanKirakira(Mesh);
       }else if (max> 75) {
        int rndm = int(random(5));
        //if(rndm > 3) kaidanKirakira(Mesh);
        if(rndm > 3) Mesh.drawMesh();
      }

  
}
void zoomInOut(triMesh Mesh) {
  float rate = map(sin(radians(frameCount)), -1, 1, 0, 1);
  Mesh.triInTri(rate);
}

void kaidan(triMesh Mesh) {
  for (float i=0; i<1.0; i+=0.1) {
    Mesh.triInTri(i);
  }
}

int kiraCount = 0;
void kaidanKirakira(triMesh Mesh) {
  //if(frameCount%3 == 0) kiraCount ++;

  for (float i=0; i<1.0; i+=0.1) {
    //Mesh.triInTri(i, Mesh.retroColor[(int)(Mesh.pos[0].x +Mesh.pos[2].y+ kiraCount+i*10)%24 ]);
    colorMode(HSB, 180, 100, 100);
    color tmp = color((i*180+frameCount/2 + Mesh.pos[0].x + Mesh.pos[2].y)%180, 100, 70);
    Mesh.triInTri(i, tmp);
    colorMode(RGB, 255, 255, 255);
  }
}




//=========/

int checkCount = 0;
int[][] checkVec = new int[10][3];

void mouseReleased() {

  if (!dragPnt && !setMesh) {
    vec[vecCount] = new PVector(mouseX, mouseY);
    vecCount++;
  }

  if (setMesh && !dragPnt) {
    for (int i=0; i<vecCount; i++) {
      float dis = dist(vec[i].x, vec[i].y, mouseX, mouseY);
      if (dis < 10) {
        checkVec[meshCount][checkCount] = i;
        checkCount++;
        if (checkCount == 3) {
          color tmpColor = color(int(random(255)), int(random(255)), int(random(255)));
          mesh[meshCount] = new triMesh(checkVec[meshCount], tmpColor );
          meshCount ++;
          checkCount = 0;
          /*
          for(int j=0; j<meshCount; j++){
           println(j + " : "  + mesh[j].check[0] + "," + mesh[j].check[1] + "," + mesh[j].check[2]);
           }
           */
        }
      }
    }
  }
}

void mouseDragged() {
  if (dragPnt) {

    for (int i=0; i<vecCount; i++) {
      float dis = dist(mouseX, mouseY, vec[i].x, vec[i].y);
      if (dis < 20) {
        vec[i] = new PVector(mouseX, mouseY);
      }
    }
  }
}

void keyPressed() {

  if (key == 'd') {
    dragPnt =! dragPnt;
  }
  if (key == 'm') {
    setMesh =! setMesh;
  }

  if (key == ' ') {
    writer = createWriter("output.txt");

    for (int i=0; i<meshCount; i++) {

      for (int j=0; j<3; j++) {

        writer.print(vec[mesh[i].check[j]].x + "," + vec[mesh[i].check[j]].y);
        if (j!=2) {
          writer.print(",");
        }
      }
      writer.println();
    }
    writer.flush();
    exit();
  }

  if (key == 'l') {
    loadTxtFile();
    loaded = true;
  }

  if (key == 's') {
    showPoint = ! showPoint;
  }
  println("dragPnt : " + dragPnt);
  println("setMesh : " + setMesh);
  println("showPoint : " + showPoint);
  println("//==============================//");
}

void stop() {
  writer.close();
  player.close();
  minim.stop();
  super.stop();
}

PVector[][] pos;
triMesh[] loadMesh;

void loadTxtFile() {
  String[] data = loadStrings("output.txt");
  println(data.length);
  loadMesh = new triMesh[data.length];

  pos = new PVector[data.length][3];

  for (int i=0; i<data.length; i++) {
    println("data:" + data[i]);
    String[] tmp = data[i].split(",");

    println(int(tmp[0]) + ":" + int(tmp[1]) + ":" + int(tmp[2]) +":"+int(tmp[3]) + ":" + int(tmp[4]) +":" + int(tmp[5])); 
    //*********
    int[] tmp2  = new int[6];
    for (int j=0; j<6; j++) {
      tmp2[j] = int(tmp[j]);
    }
    println(tmp2);
    loadMesh[i] = new triMesh(tmp2, color(int(random(255)), int(random(255)), int(random(255))), 10);
  }
}

