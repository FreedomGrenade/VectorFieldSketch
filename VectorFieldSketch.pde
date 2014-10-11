import java.util.*;

String filename, extension;
VectorField v;
ImageManipulator iM;
PImage image;
color backgroundColor;
PGraphics graphics;

public void setup() {
  filename = "d";
  extension = "jpg";
  image = loadImage(filename+"."+extension);
  size(image.width,image.height);    
  graphics = g;

 iM = new ImageManipulator(image, color(255), 0);               // Default is black, with no edge effect 

  v = new VectorField(iM);
  //v.normalize();                                    // makes only the direction of the vector field significant
  v.scale(0.01);                                     // how effective the vectorfield is (use small numbers, very small if the VectorField isn't normalized);
  v.addForce(new PVector(0.0,0.02));                  
  backgroundColor = color(255);
  background(backgroundColor);

}
public void draw() {
  // public Dot(PImage referenceImage, PVector position, PVector velocity, int life, float maxVelocity, boolean normalize, boolean accelerate, boolean wrap, ColorModes colMode, color dotColor, float colorWeight, VectorField vector, PGraphics graphics) {
  for (int i = 0; i < 100; i++) {
   PVector position = new PVector(random(width),random(height));
   Dot d = new Dot(image, position, PVector.fromAngle(random(TWO_PI)), 1000, 1.0, true, true, true, ColorModes.AVGCOLOR, image.get((int)position.x,(int)position.y),0.01 ,v, graphics);
   //d.customRGBadd(2,0,1);
   d.setStuckVelocity(0.01);
   d.fullIteration();
  }
}

public class MyVF extends VectorField{  // use this instead of it's super to change the constructor and update();

  public MyVF () {
    this(width,height);
  }
  
  public MyVF(ImageManipulator iM) {
    super(iM);
  }  
  
  public MyVF (int width_, int height_) {   
    this.width_ = width_;
    this.height_ = height_;
    values = new PVector[width_*height_];
    //////////////////////////////////////////////
    
    ///////////////////////////////////////////////
  }
  
  public void update() {
     ////////////////////////////////////////////

     ////////////////////////////////////////////
  }
  
}


public void keyPressed() {
    save("saves/"+filename+"_"+((Integer)millis()).toString()+"("+key+")"+"."+extension);   // don't press an invalid key
}
