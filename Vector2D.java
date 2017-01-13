import processing.core.*;

public class Vector2D {
  public float x, y;
  public Vector2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public Vector2D getUnitVector() {
    return new Vector2D( x / getMagnitude(), 
                         y / getMagnitude());
  }
  
  public float getMagnitude() {
    return PApplet.sqrt(
               PApplet.pow(x,2) + 
               PApplet.pow(y,2));
  }
  
  public boolean equals(Vector2D vec) {
    return (x == vec.x && y == vec.y);
  }
  
  public boolean isParallel(Vector2D vec) {
    return getUnitVector().equals(vec.getUnitVector());
  }
  
  public float distanceTo(Vector2D vec) {
    return PApplet.sqrt(
              PApplet.pow(vec.x - x, 2) +
              PApplet.pow(vec.y - y, 2));
  }
  
  //public Vector2D cross(Vector2D vec) {
  //  return x * vec.y - y * vec.x;
  //}
}