public class ImageManipulator{
  PImage img;
  int red, green, blue;
  int width_, height_;
  int edgeEffect;
  
  public ImageManipulator (PImage img) {
    this(img, color(0), 0);
  }
  
  public ImageManipulator (PImage img, color seekcolor, int edgeEffect) {
    this.img = img;
    width_ = img.width;
    height_ = img.height;
    red = seekcolor >> 16 & 0xFF;
    green = seekcolor >> 8 & 0xFF;
    blue = seekcolor >> 0 & 0xFF;
    this.edgeEffect = edgeEffect;
  }
  
  public PVector[] getVF() {
    PVector[] result = new PVector[width_*height_];
    
    int[] grey = greyScale();
    
    for (int i = 0; i < result.length; i++) {
      result[i] = calcSpot(i,grey);    
    }
    return result;
  }
  
  public int getW() {
    return width_;
  }
  
  public int getH() {
    return height_;
  }
  
  public int[] greyScale() {
    img.loadPixels();
    int[] result = new int[img.pixels.length];
    for(int i = 0; i < img.pixels.length; i++) {                                      // Create a 'greyscale' image based on the difference from the r g b color
        result[i] = (int)((abs((img.pixels[i] >> 16 & 0xFF) - red) + abs((img.pixels[i] >> 8 & 0xFF) - green) + abs((img.pixels[i] & 0xFF) - blue))*0.33333); 
    }
    return result;
  }
  
  private PVector calcSpot(int iCenter, int[] scale) {
     PVector[] surround = new PVector[8];        // a vector array with 8 vectors pointing to the 8 outer cells around a cell
     surround[0] = new PVector(-1,-1);
     surround[1] = new PVector(0,-1);
     surround[2] = new PVector(+1,-1);
     surround[3] = new PVector(-1,0);
     surround[4] = new PVector(+1,0);
     surround[5] = new PVector(-1,+1);
     surround[6] = new PVector(0,+1);
     surround[7] = new PVector(+1,+1);           //
   
     PVector sum = new PVector(0,0);             // sum of the resulting vectors
     int xtemp = (int)(iCenter%width_);
     int ytemp = (int)(iCenter/width_);
   
     for (int i = 0; i < surround.length; i++) {
       int xm = (int)surround[i].x+xtemp;
       int ym = (int)surround[i].y+ytemp;

       // this will treat the outside edge of the image as either pulling in -255 or pushing out 255 depending on edgeEffects value   
       // instead, maybe just wrap the greyscale edges?
       if (xm < 0 || xm >= width_ || ym < 0 || ym >= height_) {
         surround[i].setMag(edgeEffect);              // this is outside of the image so use the magnitude of edgeEffect instead
       } else {
         surround[i].setMag(scale[iCenter] - scale[xm+ym*width_]);   // this point is inside the image so use the difference between the 'center' and current point
       }
       sum.add(surround[i]);
     }
     return sum;
  }
  
  public PImage blur(int amount) {
    return null;
  }
}
