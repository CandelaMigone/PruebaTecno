//esto es la libreria de OpenCv :3
import gab.opencv.*;
import processing.video.*;
// la declaramos
OpenCV opencv;

//definicion 
Capture camara;
int ancho = 640;
int alto = 480;

float posX = 0;  // Posición X actual del círculo
float posY = 0;  // Posición Y actual del círculo
float suavidad = 0.1;  // Ajusta la suavidad del seguimiento (0.0 - 1.0)
ArrayList <Contour> contornos;
boolean invertir = false;
PImage ratasAmigas;
PImage kitchen;
PImage remy2;

void setup() {
  size (1280, 720);
  //devuelve la lista de camaras disponibles
  String[] listaDeCamaras = Capture.list();
  printArray ( listaDeCamaras);
  //inicialización
  camara = new Capture(this, ancho, alto);
  opencv = new OpenCV (this, ancho, alto);
  

  camara.start();
  ratasAmigas = loadImage("ratasAmigas.png");
  kitchen = loadImage("cocina.png");
  remy2 = loadImage("remy2.png");
  
}
void draw () {
int umbral = int (map (252, 0, 255, 0, 256));
  //pregunto si hay un nuevo fotograma disponible

  if (camara.available()) {
    //lee el nuevo fotograma
    camara.read();

    //cargo en OpenCV la imagen de la camara
    opencv.loadImage(camara);
    PVector pixelMasBrillante = opencv.max();
    float objetivoX =  width -pixelMasBrillante.x;
    float objetivoY = pixelMasBrillante.y;
    
    //invertir los colores
    if (invertir) {
      opencv.invert();
    }
    opencv.threshold (umbral);
    
    //busca contornos
    contornos = opencv.findContours();
    PImage salida = opencv. getOutput();
    stroke (255,5,0);
    //image( salida, 0, 0);

    
    posX = lerp(posX, objetivoX, suavidad);
    posY = lerp(posY, objetivoY, suavidad);

    background(0);
    image(kitchen, 0,0,1280,720);
    image(remy2, 550,50,150,150);
   // ellipse(posX,posY,70,70);
    image(ratasAmigas,400, 400, 275, 200);
    ellipse(pixelMasBrillante.x+50, pixelMasBrillante.y+50,50,50);
    //stroke (0,255,0);
    //cada contorno es un blob, osea que estoy capturando un blob, reccoro la lista de Blobs  (contornos) 
    /*for ( Contour esteContorno : contornos ){
      //dibujo cada uno de ellos
      //esteContorno.draw();
      //lo transforma en un contorno mas sencillo
    /*  Contour contornoAproximado = esteContorno.getPolygonApproximation();
      //obtener los puntos del nuevo contorno
      ArrayList <PVector> puntos = contornoAproximado.getPoints();
      //dibujo un poligono con el contorno
      beginShape();
      for (PVector point : puntos ) {
        
       vertex (point.x, point.y);
      }
     endShape();
   }*/
  }
  
}
