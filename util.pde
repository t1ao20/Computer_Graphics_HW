public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
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
    // You need to check the coordinate p(x,v) if inside the vertexes.
    int n = vertexes.length;
    boolean inside = false;
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
            inside = !inside;
        }
    }

    return inside;
}

public Vector3[] findBoundBox(Vector3[] v) {    
    // TODO HW2
    // You need to find the bounding box of the vertexes v.

    Vector3 recordminV = new Vector3(Float.MAX_VALUE);
    Vector3 recordmaxV = new Vector3(Float.MIN_VALUE);
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
    // And the other is the vertexes of the "boundary".
    // The output is the vertexes of the polygon.

    for (int i = 0; i < boundary.length; i++) {
        output.clear();
        Vector3 edgeStart = boundary[i];
        Vector3 edgeEnd = boundary[(i + 1) % boundary.length];
        
        Vector3 currPoint = input.get(input.size() - 1);  // 上一個點初始化為最後一個點
        
        for (Vector3 nextPoint : input) {
            boolean currInside = checkPointInside(edgeStart, edgeEnd, currPoint);
            boolean nextInside = checkPointInside(edgeStart, edgeEnd, nextPoint);
            
            if (nextInside) {
                if (!currInside) {
                    // Rule 4: 交點從外到內
                    output.add(findIntersection(edgeStart, edgeEnd, currPoint, nextPoint));
                }
                // Rule 1: P 在內部
                output.add(nextPoint);
            } else if (currInside) {
                // Rule 2: 交點從內到外
                output.add(findIntersection(edgeStart, edgeEnd, currPoint, nextPoint));
            }
            
            // 更新當前點
            currPoint = nextPoint;
        }
        
        // 更新輸入點集合
        input.clear();
        input.addAll(output);
    }

    return output.toArray(new Vector3[0]);
}

public boolean checkPointInside(Vector3 edgeStart, Vector3 edgeEnd, Vector3 checkPoint) {
   
    float boundary_X =  edgeEnd.x - edgeStart.x;
    float boundary_Y =  edgeEnd.y - edgeStart.y;
    float point_X =  checkPoint.x - edgeStart.x;
    float point_Y =  checkPoint.y - edgeStart.y;

    return ((boundary_X * point_Y) - (boundary_Y * point_X) < 0);
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
public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;
    Vector3 v0 = vertex[0];
    Vector3 v1 = vertex[1];
    Vector3 v2 = vertex[2];

    Vector3 v0v1 = v1.sub(v0);
    Vector3 v0v2 = v2.sub(v0);
    Vector3 n = Vector3.cross(v0v1, v0v2);

    float d = -Vector3.dot(n, v0);
    float z = (-n.x * x - n.y * y - d) / n.z;

    return z;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.

    float[] result = { 0.0, 0.0, 0.0 };

    return result;
}
