PImage img;
float angle = 0;
PVector pos = new PVector(50,50);
PVector vel = new PVector(2,3);

P4Vector[] points = new P4Vector[16];

void setup() {
  size(800, 800, P3D);
  smooth();
  
  img = loadImage("KakaoTalk_20210529_174058908.jpg");
  
  
  points[0] = new P4Vector(-1, -1, -1, 1);  //하이퍼큐브의 꼭짓점 생성
  points[1] = new P4Vector(1, -1, -1, 1);
  points[2] = new P4Vector(1, 1, -1, 1);
  points[3] = new P4Vector(-1, 1, -1, 1);
  points[4] = new P4Vector(-1, -1, 1, 1);
  points[5] = new P4Vector(1, -1, 1, 1);
  points[6] = new P4Vector(1, 1, 1, 1);
  points[7] = new P4Vector(-1, 1, 1, 1);
  points[8] = new P4Vector(-1, -1, -1, -1);
  points[9] = new P4Vector(1, -1, -1, -1);
  points[10] = new P4Vector(1, 1, -1, -1);
  points[11] = new P4Vector(-1, 1, -1, -1);
  points[12] = new P4Vector(-1, -1, 1, -1);
  points[13] = new P4Vector(1, -1, 1, -1);
  points[14] = new P4Vector(1, 1, 1, -1);
  points[15] = new P4Vector(-1, 1, 1, -1);
}

void draw() {
  
  image(img, 0, 0, width, height);
  translate(0, 0, 100);
  
  pos.add(vel);
  
  if(pos.x < 0 || pos.x>width){
    vel.x*=-1;
  }
  
  if(pos.y < 0 || pos.y>height){
    vel.y*=-1;
  }
  
  translate(pos.x, pos.y);
  
  rotateX(radians(40));
  rotateY(radians(40));
  

     
    
  
  PVector[] projected3d = new PVector[16];

  for (int i = 0; i < points.length; i++) {
    P4Vector v = points[i];

    float[][] rotationXY = {              //회전 xy 행렬
      {cos(angle), -sin(angle), 0, 0},
      {sin(angle), cos(angle), 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
    };

    float[][] rotationZW = {              //회전 zw 행렬
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, cos(angle), -sin(angle)},
      {0, 0, sin(angle), cos(angle)}
    };


    P4Vector rotated = matmul(rotationXY, v, true);
    rotated = matmul(rotationZW, rotated, true);
    
    float distance = 2;
    float w = 1 / (distance - rotated.w);

    float[][] projection = {
      {w, 0, 0, 0},
      {0, w, 0, 0},
      {0, 0, w, 0}
    };
    
    PVector projected = matmul(projection, rotated);
    float f = frameCount;
    if (f < 3600) {
      projected.mult(width/(16+f/35)); //1분 이전 모서리의 길이
    }else{
      projected.mult(width/(16+f*2/35)); //1분 이후 모서리의 길이
    }
    projected3d[i] = projected;
    strokeWeight(0); //꼭짓점 크기
    stroke(191, 161, 172);
    noFill();

    point(projected.x, projected.y, projected.z);
    
    if(frameCount>1260){//특정 시간 지난 이후 사라짐.
      projected3d[i].sub(projected);
      
    /*println(frameCount);*/
    }
}

  //하이퍼큐브의 모서리 생성
  for (int i = 0; i < 4; i++) {
    connect(0, i, (i+1) % 4, projected3d );
    connect(0, i+4, ((i+1) % 4)+4, projected3d);
    connect(0, i, i+4, projected3d);
  }

  for (int i = 0; i < 4; i++) {
    connect(8, i, (i+1) % 4, projected3d );
    connect(8, i+4, ((i+1) % 4)+4, projected3d);
    connect(8, i, i+4, projected3d);
  }

  for (int i = 0; i < 8; i++) {
    connect(0, i, i + 8, projected3d);
  }

  //angle = map(mouseX, 0, width, 0, TWO_PI);
  angle += 0.02;
}

void connect(int offset, int i, int j, PVector[] points) {
  PVector a = points[i+offset];
  PVector b = points[j+offset];
  strokeWeight(4); 
  stroke(191, 161, 172);
  line(a.x, a.y, a.z, b.x, b.y, b.z);
}
