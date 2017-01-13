float t;

void setup() {
  t = 0;
  size(1000, 298);
}

void draw() {
  background(255,255,255);
  strokeWeight(2);
  strokeCap(SQUARE);
  
  float lineDensity = 0.11f;
  float cosDensity  = 2f;
  float sinAmplitude = 30;
  float shift = PI;
  
  ArrayList<Line>[] polys = createPolys(7);
  
  for (int i = 0; i < width * lineDensity; i++) {
    float x = (i + 0.5f) * width / (width * lineDensity);
    Line cosline = new Line( x + sinAmplitude * -sin(shift + cosDensity * TWO_PI * ((i + t) / (width * lineDensity))),
                             height,
                             x,
                             height / 2 + (height / 2) * 0.5 * cos(shift + cosDensity * (TWO_PI * (x / width))));
    
    ArrayList<Line> constructedLines = constructLines(polys, cosline);
    
    for (Line l : constructedLines ) {
      line(l.a.x, l.a.y, l.b.x, l.b.y);
    }
    
  }
  
  //t += 0.1f;
}

void drawPolygon(ArrayList<Line> poly) {
  for (Line l : poly) {
    line(l.a.x, l.a.y, l.b.x, l.b.y);
  }
}

ArrayList<Line> constructLines(ArrayList<Line>[] shapes, Line guide) {
   ArrayList<Line> cLine = new ArrayList<Line>();
   Line infiniteGuide = new Line(guide.b, new Vector2D(guide.b.x + guide.getDirectionVector().getUnitVector().x * width,
                                                       guide.b.y + guide.getDirectionVector().getUnitVector().y * width));
    
   ArrayList<Vector2D> intersectionPoints = new ArrayList<Vector2D>();
   
   ArrayList<Vector2D> negativeIntersections = new ArrayList<Vector2D>();
   for (int s = 0; s < shapes.length; s++) {
       for (Line l : shapes[s]) {
         //cLine.add(l);
         if (guide.hasIntersection(l)) {
            intersectionPoints.add(guide.getIntersection(l));
         }
         else if (infiniteGuide.hasIntersection(l)){
           negativeIntersections.add(infiniteGuide.getIntersection(l));
         }
       }
   }
   
   // sort intersections by distance from start point of guide
   ArrayList<Vector2D> sortedIntersections = new ArrayList<Vector2D>();
   while (intersectionPoints.size() != 0) {
     float shortestD = 100000f;
     Vector2D shortestV = null;
     
     for (Vector2D p : intersectionPoints) {
       float distance = guide.a.distanceTo(p);
       if (distance < shortestD) {
         shortestV = p;
         shortestD = distance;
       }
     }
     if (shortestV != null) {
       intersectionPoints.remove(shortestV);
       sortedIntersections.add(shortestV);
     }
   }

  // sort negative intersections by distnace from end point of guide
  ArrayList<Vector2D> sortedNegatives = new ArrayList<Vector2D>();
  while (negativeIntersections.size() != 0) {
    float shortestD = 1000000f;
    Vector2D shortestV = null;
    
    for (Vector2D p : negativeIntersections) {
      float distance = guide.b.distanceTo(p);
      if (distance < shortestD) {
        shortestV = p;
        shortestD = distance;
      }
    }
    if (shortestV != null){
      negativeIntersections.remove(shortestV);
      sortedNegatives.add(shortestV);
    }
  }
   
   if (sortedIntersections.size() == 0)
     cLine.add(guide);
   else
   {
     cLine.add(new Line(guide.a, sortedIntersections.get(0)));
     // An even number means a line must be drawn to the end of the guide
     if (sortedIntersections.size() % 2 == 0) {
       cLine.add(new Line(sortedIntersections.get(sortedIntersections.size() - 1), guide.b));
     }
   }
   
   if (sortedNegatives.size() != 0) {
     if (sortedNegatives.size() % 2 == 0) {
       cLine.add(new Line(sortedNegatives.get(0), sortedNegatives.get(1)));
     }
     else {
       cLine.add(new Line(guide.b, sortedNegatives.get(0)));
     }
   }
   
   //fill(0, 0, 0);
   //text(sortedIntersections.size(), guide.a.x, 10);
   //cLine.add(guide);
   return cLine;
}

ArrayList<Line>[] createPolys(int numSolids) {
  int xMargin = (int)(0.08f * width);
  
  float maxSize = height * 0.25f;
  float minSize = height * 0.1f;
  
  float weightPoint = 0.25f;
  
  ArrayList<Line> polyLines[] = new ArrayList[numSolids];
  
  // I separated this as a second transformation to easily change weighting above
  weightPoint = xMargin + ((width - (2 * xMargin)) * weightPoint);
  
  for (int i = 0; i < numSolids; i++) {
    float solidPct = (float) i / (numSolids - 1);

    int size = (int)map(solidPct, 0, 1, minSize, maxSize);
     
    int xPosition = (int)lerp(
                          lerp(xMargin, 
                               weightPoint, 
                               solidPct),
                          lerp(weightPoint, 
                               width - xMargin, 
                               solidPct), 
                          solidPct);
    xPosition = (int)map ( xPosition,
                           xMargin, width - xMargin,
                           xMargin + size / 2,
                           width - xMargin - (size / 2));
                                  
    polyLines[i] = createPoly(  xPosition,
                                height / 2,
                                size,
                                i + 3);
  }
  return polyLines;
}

ArrayList<Line> createPoly(int x, int y, int size, int num_sides) {
    ArrayList<Line> edges = new ArrayList<Line>();
  
    float angle = TWO_PI / (float)num_sides;
  
    for (int i = 0; i < num_sides; i++) {
      edges.add(new Line( x + size *  sin(i * angle),
                          y + size * -cos(i * angle),
                          x + size *  sin((i + 1) * angle),
                          y + size * -cos((i + 1) * angle)));  
  }
  return edges;
}