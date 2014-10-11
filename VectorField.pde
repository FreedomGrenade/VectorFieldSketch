public class VectorField {
  int width_;
  int height_;
  PVector[] values;
  
  public VectorField() {
    this(width,height);
  }
  
  public VectorField (int width_, int height_) {   //creates a random VectorField
    this.width_ = width_;
    this.height_ = height_;
    values = new PVector[width_*height_];
    for (int i = 0; i < values.length; i++) {
      values[i] = PVector.fromAngle(random(TWO_PI));
    }
  }
    
  public VectorField (ImageManipulator man) {
    width_ = man.getW();
    height_ = man.getH();
    values = man.getVF();
  }

  public void addForce(PVector ambient) {
    for(int i = 0; i < values.length; i++) {
        values[i].add(ambient);
    }    
  }


  public void normalize() {  // use this to avoid drasticly high forces
    for(int i = 0; i < values.length; i++) {
        values[i].normalize();
    }    
  }


  public void scale(float amount) {  // the original values are the sum of 8 values ranging from -255 to 255 because it's based difference of color 
    for(int i = 0; i < values.length; i++) {
        values[i].mult(amount);
    }    
  }
  

  public void update() {
    // doesn't do anything, override with another Class
  }
 
  public PVector getValue(float x, float y) {
    return getValue((int)x, (int)y);
  }


  public PVector getValue(int x, int y) {
    return values[constrain(x,0,width_-1)+constrain(y,0,height_-1)*width_];
  }

  
  public PVector getValueRelative(int refW, int refH, float x, float y) {  // if the vectorfield has more or less cells than the sketch (stretches vectorfield to fit sketch)
    return getValue(x*width_/refW,y*height_/refH);
  }
  
  public void drawVFlines(PGraphics graphics, int offset) {
    graphics.stroke(255,0,0);
    float xScale = graphics.width/width_;
    float yScale = graphics.height/height_;
    int stepx = (xScale > 5) ? 1 : 10;    // 
    int stepy = (yScale > 5) ? 1 : 10;    //
    for (int y = 0; y < height_; y+=stepy) {
      int i = y*width_;
      for (int x = 0; x < width_; x+=stepx) {
         int x_ = (int)(x*xScale+values[i+x].x*50);
         int y_ = (int)(y*yScale+values[i+x].y*50);
         graphics.line(x*xScale,y*yScale,x_,y_);
         graphics.set((int)(x*xScale+values[i+x].x*offset),(int)(y*yScale+values[i+x].y*offset),color(255));
      }
    }
  } 
  
  public void drawVFraster(PGraphics graphics) {
    float scaler = 255 / TWO_PI;
    for (int y = 0; y < graphics.height; y++) {
      for (int x = 0; x < graphics.width; x++) {
        graphics.set(x,y,color(127+(getValueRelative(graphics.width,graphics.height,x,y)).heading()*scaler));
      }
    }
  }

  public int getW() {
    return width_;
  }
  
  public int getH() {
    return height_;
  }
  
  public int getIndex(int x, int y) {
    return y*width_+x;
  }

  public PVector getXY(int i) {
    return new PVector(i%width_,(int)i/width_);
  }
}

