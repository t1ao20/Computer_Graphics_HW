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
    boolean result = false;
    int n = vertexes.length; //numbers of vertexes

    for(int i = 0,j = n - 1; i < n; j = i++){
        float xi = vertexes[i].x, yi = vertexes[i].y; // current x, y of i
        float xj = vertexes[j].x, yj = vertexes[j].y; // previous x, y of j

        if(((yi > y) != (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi)){
            result = !result;
        }
    }
    return result;
}

public Vector3[] findBoundBox(Vector3[] v) {
    Vector3 recordminV = new Vector3(1.0 / 0.0);
    Vector3 recordmaxV = new Vector3(-1.0 / 0.0);
    // TODO HW2
    // You need to find the bounding box of the vertexes v.
    for(Vector3 vertex : v){
        // find min
        if(vertex.x < recordminV.x) recordminV.x = vertex.x;
        if(vertex.y < recordminV.y) recordminV.y = vertex.y;
        if(vertex.z < recordminV.z) recordminV.z = vertex.z;

        // find max
        if(vertex.x > recordmaxV.x) recordmaxV.x = vertex.x;
        if(vertex.y > recordmaxV.y) recordmaxV.y = vertex.y;
        if(vertex.z > recordmaxV.z) recordmaxV.z = vertex.z;
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
    //iterate all boundary
    for(int i = 0;i < boundary.length;i++){
        output.clear();
        Vector3 start_edge = boundary[i];
        Vector3 end_edge = boundary[(i+1) % boundary.length];
        Vector3 P = input.get(input.size() - 1); //previous vertex

        for(int j = 0; j < input.size();j++){
            Vector3 Q = input.get(j); // current vertex

            if(isInside(P,start_edge,end_edge)){
                if(isInside(Q,start_edge,end_edge)){
                    output.add(Q);
                }
                else{
                    output.add(getIntersection(P,Q,start_edge,end_edge));
                }
                
            }
            else if(isInside(Q,start_edge,end_edge)){
                output.add(getIntersection(P,Q,start_edge,end_edge));
                output.add(Q);
            }
            P = Q;
        }
        input.clear();
        input.addAll(output);
    }

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;
}

private boolean isInside(Vector3 p, Vector3 start, Vector3 end){
    return (end.x - start.x) * (p.y - start.y) < (end.y - start.y) * (p.x - start.x);
}

private Vector3 getIntersection(Vector3 p,Vector3 q, Vector3 start, Vector3 end){
    float a1 = q.y - p.y;
    float b1 = p.x - q.x;
    float c1 = a1*p.x + b1 * p.y;
    
    float a2 = end.y - start.y;
    float b2 = start.x - end.x;
    float c2 = a2 * start.x + b2 * start.y;

    float det = a1 * b2 - a2 * b1;
    
    float x = (b2 * c1 - b1 * c2) / det;
    float y = (a1 * c2 - a2 * c1) / det;
    return new Vector3(x,y,0);
}

public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;

    Vector3 A = vertex[0];
    Vector3 B = vertex[1];
    Vector3 C = vertex[2];

    float areaABC = Math.abs((B.x - A.x) * (C.y - A.y) - (B.y - A.y) * (C.x - A.x));

    float alpha = Math.abs((B.x - x) * (C.y - y) - (B.y - y) * (C.x - x)) / areaABC;
    float beta = Math.abs((C.x - x) * (A.y - y) - (C.y - y) * (A.x - x)) / areaABC;
    float gamma = Math.abs((A.x - x) * (B.y - y) - (A.y - y) * (B.x - x)) / areaABC;

    return alpha * A.z + beta * B.z + gamma * C.z;
}

float[] barycentric(Vector3 P, Vector4[] verts) {
    
    
    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    Vector4 AW = verts[0];
    Vector4 BW = verts[1];
    Vector4 CW = verts[2];
    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.
    // Please notice that you should use Perspective-Correct Interpolation otherwise
    // you will get wrong answer.

    Vector3 v0 = B.sub(A);
    Vector3 v1 = C.sub(A);
    Vector3 v2 = P.sub(A);

    float d00 = Vector3.dot(v0, v0);
    float d01 = Vector3.dot(v0, v1);
    float d11 = Vector3.dot(v1, v1);
    float d20 = Vector3.dot(v2, v0);
    float d21 = Vector3.dot(v2, v1);
    float denom = d00 * d11 - d01 * d01;

    float beta = (d11 * d20 - d01 * d21) / denom;
    float gamma = (d00 * d21 - d01 * d20) / denom;
    float alpha = 1.0f - beta - gamma;

    alpha = alpha * AW.w;
    beta  = beta * BW.w;
    gamma = gamma * CW.w;

    float sum = alpha + beta + gamma;

    alpha = alpha / sum;
    beta = beta / sum;
    gamma = gamma / sum;

    return new float[] { alpha, beta, gamma };
}

Vector3 interpolation(float[] abg, Vector3[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

Vector4 interpolation(float[] abg, Vector4[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

float interpolation(float[] abg, float[] v) {
    return v[0] * abg[0] + v[1] * abg[1] + v[2] * abg[2];
}
