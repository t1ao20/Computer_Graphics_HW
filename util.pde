public boolean checkInBox(float x1, float y1) {
    // Box(20,50,width-40,height-100);
    // size(1000, 800);
    float width = 1000;
    float height = 800;
    if (x1 > 20 && x1 < width - 40 && y1 > 50 && y1 < height - 100) {
        return true;
    }
    return false;
    
}

public void CGLine(float x1, float y1, float x2, float y2, color c) {
    
    // stroke(0);
    // noFill();
    // line(x1,y1,x2,y2);
    int dx = (int)abs(x2 - x1);
    int dy = (int)abs(y2 - y1);
    int dir_x = x1 < x2 ? 1 : -1; // Increment direction: 1 is right or -1 is left
    int dir_y = y1 < y2 ? 1 : -1;
    int err = dx - dy;

    while (true) {
        drawPoint(x1, y1, c);
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

public void CGCircle(float x, float y, float r, color c) {

    // stroke(0);
    // noFill();
    // circle(x,y,r*2);
    int xc = (int)x;
    int yc = (int)y;
    int xk=0;

    int yk = int(r);

    float d = 5/4 - r;

    drawCirclePoints(xc, yc, xk, yk, c);

    while (xk < yk) {
        
        if (d < 0) {
            d += 2 * xk + 3;
        } else {
            d += 2 * (xk - yk) + 5;
            yk--;
        }
        xk++;
        drawCirclePoints(xc, yc, xk, yk, c);
    }
    
}

public void CGEllipse(float x, float y, float r1, float r2, color c) {
    
    // stroke(0);
    // noFill();
    // ellipse(x,y,r1*2,r2*2);
    float xc = x;
    float yc = y;
    float xk = 0;
    float yk = r2;
    float d1 = r2 * r2 - r1 * r1 * r2 + 0.25f * r1 * r1;
    float dx = 2 * r2 * r2 * xk;
    float dy = 2 * r1 * r1 * yk;

    // Region 1
    while(dx < dy) {
        drawEllipsePoints(xc, yc, xk, yk, c);
        if(d1 < 0) {
            xk++;
            dx += 2 * r2 * r2;
            d1 += dx + r2 * r2;
        } else {
            xk++;
            yk--;
            dx += 2 * r2 * r2;
            dy -= 2 * r1 * r1;
            d1 += dx - dy + r2 * r2;
        }
    }
    float d2 = r2 * r2 * (xk + 0.5f) * (xk + 0.5f) + r1 * r1 * (yk - 1) * (yk - 1) - r1 * r1 * r2 * r2;
    // Region 2
    while(yk >= 0) {
        drawEllipsePoints(xc, yc, xk, yk, c);
        if(d2 > 0) {
            yk--;
            dy -= 2 * r1 * r1;
            d2 += r1 * r1 - dy;
        } else {
            xk++;
            yk--;
            dx += 2 * r2 * r2;
            dy -= 2 * r1 * r1;
            d2 += dx - dy + r1 * r1;
        }
    }
    

}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4, color c) {
    // stroke(0);
    // noFill();
    // bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    float dist = distance(p1, p2) + distance(p2, p3) + distance(p3, p4);

    for (float t = 0; t <= 1; t += 0.5f / dist) {
        float x = bezierPoint(p1.x, p2.x, p3.x, p4.x, t);
        float y = bezierPoint(p1.y, p2.y, p3.y, p4.y, t);
        drawPoint(x, y, c);
    }
}

public void CGEraser(Vector3 p1, Vector3 p2) {
    int x1 = (int)min(p1.x, p2.x);
    int x2 = (int)max(p1.x, p2.x);
    int y1 = (int)min(p1.y, p2.y);
    int y2 = (int)max(p1.y, p2.y);
    for (int i = x1; i <= x2; i++) {
        for (int j = y1; j <= y2; j++) {
            drawPoint(i, j, color(250));
        }
    }
}

public void CGSprays(float x, float y, float radius, int density, color c) {
    for (int i = 0; i < density; i++) {
        float offsetX = random(-radius, radius);
        float offsetY = random(-radius, radius);
        float distance = dist(x, y, x + offsetX, y + offsetY);
        if (distance < radius) {
            drawPoint(x + offsetX, y + offsetY, c);
        }
    }
}

public ArrayList<Vector3> Generate_CGSprays(float x, float y, float radius, int density, color c) {
    ArrayList<Vector3> points = new ArrayList<Vector3>();
    for (int i = 0; i < density; i++) {
        float offsetX = random(-radius, radius);
        float offsetY = random(-radius, radius);
        float distance = dist(x, y, x + offsetX, y + offsetY);
        if (distance < radius) {
            points.add(new Vector3(x + offsetX, y + offsetY, 0));
            drawPoint(x + offsetX, y + offsetY, c);
        }
    }
    return points;
}

public void drawPoint(float x, float y, color c) {
    stroke(c);
    if (checkInBox(x, y))
        point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

public void drawCirclePoints(float xc, float yc, float xk, float yk, color c) {
    drawPoint(xc + xk, yc + yk, c);
    drawPoint(xc - xk, yc + yk, c);
    drawPoint(xc + xk, yc - yk, c);
    drawPoint(xc - xk, yc - yk, c);
    drawPoint(xc + yk, yc + xk, c);
    drawPoint(xc - yk, yc + xk, c);
    drawPoint(xc + yk, yc - xk, c);
    drawPoint(xc - yk, yc - xk, c);
}

public void drawEllipsePoints(float xc, float yc, float xk, float yk, color c) {
    drawPoint(xc + xk, yc + yk, c);
    drawPoint(xc - xk, yc + yk, c);
    drawPoint(xc + xk, yc - yk, c);
    drawPoint(xc - xk, yc - yk, c);
}

public float bezierPoint(float a, float b, float c, float d, float t) {
    float t1 = 1 - t;
    return t1 * t1 * t1 * a + 3 * t1 * t1 * t * b + 3 * t1 * t * t * c + t * t * t * d;
}