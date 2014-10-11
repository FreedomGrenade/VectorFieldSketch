public class Dot {

  private VectorField vector;
  private PImage referenceImage;
  private int width_, height_;
  private PVector position;
  private PVector velocity;
  private boolean wrap;        // wrap around edges instead of colliding
  private boolean accelerate;  // VectorField represents acceleration istead of velocity
  private boolean normalize;   // particle is going a constant rate
  private float maxVelocity;   // max speed, if <0 do not cap speed
  private boolean mortal = true;
  private float stuckVelocity = 0.2;
  

  private ColorModes colMode;
  private color dotColor;
  private int red, green, blue;
  private float colorWeight;   // how much the dot's color effects the sketch (depends on color Mode)

  private int life;
  PGraphics graphics;

  public Dot(VectorField vector, PGraphics graphics) {
    this(vector.getW(), vector.getH(), new PVector(random(vector.getW()),random(vector.getH())), new PVector(0,0) , 1000, 1, true, true, false, ColorModes.SOLID, color(0), 1.0, vector, graphics);  
  }
  
  public Dot(PImage referenceImage, PVector position, PVector velocity, int life, float maxVelocity, boolean normalize, boolean accelerate, boolean wrap, ColorModes colMode, color dotColor, float colorWeight, VectorField vector, PGraphics graphics) {
    this(referenceImage.width, referenceImage.height, position, velocity, life, maxVelocity, normalize, accelerate, wrap, colMode, dotColor, colorWeight, vector, graphics);
    this.referenceImage = referenceImage;
  }

  public Dot(int width_, int height_, PVector position, PVector velocity, int life, float maxVelocity, boolean normalize, boolean accelerate, boolean wrap, ColorModes colMode, color dotColor, float colorWeight, VectorField vector, PGraphics graphics) {
    this.width_ = width_;
    this.height_ = height_;
    this.life = life;
    this.position = position.get();
    this.velocity = velocity.get();
    this.maxVelocity = maxVelocity;
    this.normalize = normalize;
    this.accelerate = accelerate;
    this.wrap = wrap;
    this.colMode = colMode;
    this.dotColor = dotColor;                          
    red = (dotColor >> 16) & 0xFF;
    green = (dotColor >> 8) & 0xFF;
    blue = dotColor & 0xFF;
    this.colorWeight = colorWeight;
    this.vector = vector;
    this.graphics = graphics;
  }
  
  public void customRGBadd(int red, int green, int blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  
  public void setGraphics(PGraphics graphics) {
    this.graphics = graphics;
  }
  
  public void immortal() {
    mortal = false;
  }
  
  public void setStuckVelocity(float minVelocity) {
    stuckVelocity = minVelocity;
  }
  
  public void kill() {
    mortal = true;
    life = 0;
  }

  public void draw() {
      graphics.set((int)position.x, (int)position.y, drawColor(graphics.get((int)position.x, (int)position.y)));
  }


  private void update() {
    if (isAlive()) {
      
      if (accelerate) {
        velocity.add(vector.getValueRelative(width_,height_,(int)position.x, (int)position.y));
      } else {
        //println(vector+"  "+w+":"+h+"    " + velocity.x +":"+ velocity.y + "    " + position.x +":"+ position.y );
        velocity = (vector.getValueRelative(width_,height_,(int)position.x, (int)position.y)).get();
      }
       
      if (normalize) {                        //IF normalized it will always set the velocity to the maxVelocity
        velocity.normalize();
        velocity.setMag(abs(maxVelocity));
      } else if (maxVelocity > 0 && velocity.mag() > maxVelocity) {      // if not normalized AND there is a maxVelocity AND going too fast, then clip velocity to maxVelocity
        velocity.setMag(maxVelocity);            
      } 

      position.add(velocity);
       
      if (wrap) {
        position.x = (position.x % width_ + width_) % width_;
        position.y = (position.y % height_ + height_) %  height_;
      } else {
        position.x = constrain(position.x, 0, width_-1);
        position.y = constrain(position.y, 0, height_-1);
        if (position.x <= 0 || position.x >= (width_-1)) velocity.x = -velocity.x;
        if (position.y <= 0 || position.y >= (height_-1)) velocity.y = -velocity.y;
      }
      if (mortal) life--;
    }
  }  


  private color drawColor(color inputColor) {
    switch (colMode) {
      case ADDCOLOR:
        return incColor(inputColor);
      case AVGCOLOR:
        return lerpColor(inputColor, dotColor, colorWeight);
      case CURRENT:
      if (referenceImage != null) {
        return lerpColor(inputColor, referenceImage.get((int)position.x,(int)position.y), colorWeight);
      } else {
        return dotColor;
      }
      case SOLID: default:
        return dotColor;
    }
  } 


  private color incColor(color base) {
    return color(   constrain((base >> 16 & 0xFF) + red, 0, 255), 
                    constrain((base >> 8 & 0xFF)  + green, 0, 255), 
                    constrain((base & 0xFF)       + blue, 0, 255)         );
  }


  public boolean isAlive() {
    return (life >= 0);
  }
  
  public boolean stuck() {                                    //use this to avoid single pixels 'burning in' the image
    return (velocity.x < stuckVelocity) && (velocity.y < stuckVelocity);          
  }


  public void fullIteration() {
    mortal = true;
    while (isAlive()) {
      update();
      if (!stuck()) draw();                                   // don't kill if stuck, if a changing vectorfield is used it might get unstuck and draw again
    }
  }
  
  public PVector getPosition() {
    return position.get();
  }
}



