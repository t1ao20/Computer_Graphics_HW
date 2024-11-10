public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // Please paste your code from HW1 CGLine.

    int dx = (int)abs(x2 - x1);
    int dy = (int)abs(y2 - y1);
    int dir_x = x1 < x2 ? 1 : -1; // Increment direction: 1 is right or -1 is left
    int dir_y = y1 < y2 ? 1 : -1;
    int err = dx - dy;

    // while (true) {
    int steps = Math.max(dx, dy); // Set total steps to maximum delta
    // int steps = dx+dy;
    for (int i = 0; i <= steps; i++) {
        drawPoint(x1, y1, color(0, 0, 0));
        if (x1 == x2 && y1 == y2) {
            break;
        }

        float e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x1 += dir_x;
        }
        if (e2 < dx) {
            err += dx;
            y1 += dir_y;
        }
    }

}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2 
    // You need to check the coordinate p(x,v) if inside the vertices. 
    // If yes return true, vice versa.
    int intercount = 0;
    int n = vertexes.length;
    for (int i = 0; i < n; i++) {
        int j = (i+1)%n;
        float xi = vertexes[i].x;
        float yi = vertexes[i].y;
        float xj = vertexes[j].x;
        float yj = vertexes[j].y;
        //check if y of the point (x, y) is between y of the two vertexes
        boolean cond1 = (y < yi != y < yj);
        float x_cross = xi + (xj - xi) * (y - yi) / (yj - yi);
        boolean cond2 = (x < x_cross);
        if(cond1 && cond2){
            intercount++;
        }
    }
    //if odd number of intersections, then the point is inside the polygon
    if(intercount%2 == 1){
        return true;
    }

    return false;
}

public Vector3[] findBoundBox(Vector3[] v) {
    
    
    // TODO HW2 
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2

    Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    for (Vector3 vertex : v) {
        recordminV.x = Math.min(recordminV.x, vertex.x);
        recordminV.y = Math.min(recordminV.y, vertex.y);
        recordminV.z = Math.min(recordminV.z, vertex.z);
        
        recordmaxV.x = Math.max(recordmaxV.x, vertex.x);
        recordmaxV.y = Math.max(recordmaxV.y, vertex.y);
        recordmaxV.z = Math.max(recordmaxV.z, vertex.z);
    }
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertices of the "boundary".
    // The output is the vertices of the polygon.
    for(int i = 0; i < boundary.length; i++){
        output.clear();
        Vector3 edgeStart = boundary[i];
        Vector3 edgeEnd = boundary[(i + 1) % (boundary.length)];
        
        Vector3 currPoint;
        Vector3 nextPoint;
        
        for(int j = 0; j < input.size(); j++){
            // 0, 1, 2, 3
            // for 0 -> 1, 1 -> 2, 2 -> 3, 3 -> 0
            currPoint = input.get(j);
            nextPoint = input.get((j + 1) % (input.size()));
            
            if(checkPointInside(edgeStart, edgeEnd, currPoint)){
                // S is inside > rule 1, 2
                if(!checkPointInside(edgeStart, edgeEnd, nextPoint)){
                    // P is outside -> rule 2
                    output.add(findIntersection(edgeStart, edgeEnd, currPoint, nextPoint));
                }
                else{
                    // P is inside -> rule 1
                    output.add(nextPoint);
                }
            }
            else{
                // S is outside -> rule 3, 4
                if(checkPointInside(edgeStart, edgeEnd, nextPoint)){
                    // P is inside -> rule 4
                    output.add(findIntersection(edgeStart, edgeEnd, currPoint, nextPoint));
                    output.add(nextPoint);
                }
            }
        }
        
        input.clear();
        input.addAll(output);
        
    }
    
    Vector3[] result=new Vector3[output.size()];
    for (int i=0; i<result.length; i+=1) {
        result[i]=output.get(i);
    }
    return result;
}


public boolean checkPointInside(Vector3 edgeStart, Vector3 edgeEnd, Vector3 checkPoint) {
   
    float boundary_X =  edgeEnd.x - edgeStart.x;
    float boundary_Y =  edgeEnd.y - edgeStart.y;
    float point_X =  checkPoint.x - edgeStart.x;
    float point_Y =  checkPoint.y - edgeStart.y;

    if((boundary_X * point_Y) - (boundary_Y * point_X) <= 0){
        return true;
    }
    
    return false;
}

public Vector3 findIntersection(Vector3 edgeStart, Vector3 edgeEnd, Vector3 p1, Vector3 p2) {
    float x1 = edgeStart.x, y1 = edgeStart.y;
    float x2 = edgeEnd.x, y2 = edgeEnd.y;
    float x3 = p1.x, y3 = p1.y;
    float x4 = p2.x, y4 = p2.y;
    
    float product = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
    float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / product;

    float x = (x1 + t * (x2 - x1));
    float y = (y1 + t * (y2 - y1));

    return new Vector3(x, y, 0);
}