import processing.core.*;

public class Line {
  public Vector2D a, b;
  
  public Line(Vector2D a, Vector2D b) {
    this.a = a;
    this.b = b;
  }
  
  public Line(float x1, float y1, float x2, float y2) {
    this(new Vector2D(x1, y1), new Vector2D(x2, y2));
  }
  
  public Vector2D getDirectionVector() {
    return new Vector2D(b.x - a.x, b.y - a.y);
  }
  
  public boolean isParallel(Line l) {
    return getDirectionVector().isParallel(l.getDirectionVector());
  }
  
  public boolean intersectsPoint(Vector2D vec) {
    Vector2D unitVector = getDirectionVector().getUnitVector();
    
    // vec.x = a.x + t ( unitVector.x)
    float t = (-a.x + vec.x) / unitVector.x;
    
    // Check if point exists on our vector
    if (t == (-a.y + vec.y) / unitVector.y) {
      // Check if it's within our line segment's bounds
      if (t * unitVector.x > getDirectionVector().getMagnitude() ||
          t * unitVector.y > getDirectionVector().getMagnitude() ||
          t * unitVector.x < 0 ||
          t * unitVector.y < 0) {
          return true;
        }
    }
    return false;
  }
  
  public boolean hasIntersection(Line l) {
    int o1 = getOrientation(   a,   b, l.a);
    int o2 = getOrientation(   a,   b, l.b);
    int o3 = getOrientation( l.a, l.b,   a);
    int o4 = getOrientation( l.a, l.b,   b);
    
    if (o1 != o2 && o3 != o4)
      return true;
    
    if (o1 == 0 && onSegment(   a, l.a,   b)) return true;
    if (o2 == 0 && onSegment(   a, l.b,   b)) return true;
    if (o3 == 0 && onSegment( l.a,   a, l.b)) return true;
    if (o4 == 0 && onSegment( l.a,   b, l.b)) return true;
    
    return false;
  }
  
  // Found in algorithm at 
  // http://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
  // 0 -> colinear
  // 1 -> clockwise
  // 2 -> counterclockwise
  private int getOrientation(Vector2D p, Vector2D q, Vector2D r) {
    int val = (int)((q.y - p.y) * (r.x - q.x) -
                    (q.x - p.x) * (r.y - q.y));
    if (val == 0) return 0; // colinear
    return (val > 0) ? 1 : 2;
  }
  
  // Checks if q lies on line segment pr
  private boolean onSegment(Vector2D p, Vector2D q, Vector2D r) {
    if (q.x <= PApplet.max(p.x, r.x) && q.x >= PApplet.min(p.x, r.x) &&
        q.y <= PApplet.max(p.y, r.y) && q.y >= PApplet.min(p.y, r.y))
        return true; 
    return false;
  }

  public Vector2D getIntersection(Line l) {
    float s1_x, s1_y, s2_x, s2_y;
    s1_x =   b.x -   a.x;   s1_y =   b.y -   a.y;
    s2_x = l.b.x - l.a.x;   s2_y = l.b.y - l.a.y;
    
    float s,t;
    s = (-s1_y * (a.x - l.a.x) + s1_x * (a.y - l.a.y)) / ( -s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (a.y - l.a.y) - s2_y * (a.x - l.a.x)) / ( -s2_x * s1_y + s1_x * s2_y);
    
    if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
    {
      // Collision detected
      return new Vector2D(a.x + (t * s1_x),
                          a.y + (t * s1_y));
    }
    return null;
  }
}