
public interface Shape {
    public void drawShape();
}

public class Point implements Shape {
    ArrayList<Vector3> points = new ArrayList<Vector3>();
    color currentColor;

    public Point(ArrayList<Vector3> p, color c) {
        points = p;
        currentColor = c;
    }

    @Override
    public void drawShape() {
        if (points.size() <= 1)
            return;
        for (int i = 0; i < points.size() - 1; i++) {
            Vector3 p1 = points.get(i);
            Vector3 p2 = points.get(i + 1);
            CGLine(p1.x, p1.y, p2.x, p2.y, currentColor);
        }
    }
}

public class Line implements Shape {
    Vector3 point1;
    Vector3 point2;
    color currentColor;

    public Line() {
    };

    public Line(Vector3 v1, Vector3 v2, color c) {
        point1 = v1;
        point2 = v2;
        currentColor = c;
    }

    @Override
    public void drawShape() {
        CGLine(point1.x, point1.y, point2.x, point2.y, currentColor);
    }

}

public class Circle implements Shape {
    Vector3 center;
    float radius;
    color currentColor;

    public Circle() {
    }

    public Circle(Vector3 v1, float r, color c) {
        center = v1;
        radius = r;
        currentColor = c;
    }

    @Override
    public void drawShape() {
        CGCircle(center.x, center.y, radius, currentColor);
    }
}

public class Polygon implements Shape {
    ArrayList<Vector3> verties = new ArrayList<Vector3>();
    color currentColor;

    public Polygon(ArrayList<Vector3> v, color c) {
        verties = v;
        currentColor = c;
    }

    @Override
    public void drawShape() {
        if (verties.size() <= 0)
            return;
        for (int i = 0; i <= verties.size(); i++) {
            Vector3 p1 = verties.get(i % verties.size());
            Vector3 p2 = verties.get((i + 1) % verties.size());
            CGLine(p1.x, p1.y, p2.x, p2.y, currentColor);
        }
    }
}

public class Ellipse implements Shape {
    Vector3 center;
    float radius1, radius2;
    color currentColor;

    public Ellipse() {
    }

    public Ellipse(Vector3 cen, float r1, float r2, color c) {
        center = cen;
        radius1 = r1;
        radius2 = r2;
        currentColor = c;
    }

    @Override
    public void drawShape() {
        CGEllipse(center.x, center.y, radius1, radius2, currentColor);
    }
}

public class Curve implements Shape {
    Vector3 cpoint1, cpoint2, cpoint3, cpoint4;
    float radius1, radius2;
    color currentColor;

    public Curve() {
    }

    public Curve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4, color c) {
        cpoint1 = p1;
        cpoint2 = p2;
        cpoint3 = p3;
        cpoint4 = p4;
        currentColor = c;
    }

    @Override
    public void drawShape() {
        CGCurve(cpoint1, cpoint2, cpoint3, cpoint4, currentColor);
    }
}

public class EraseArea implements Shape {
    Vector3 point1, point2;

    public EraseArea() {
    }

    public EraseArea(Vector3 p1, Vector3 p2) {
        point1 = p1;
        point2 = p2;
    }

    @Override
    public void drawShape() {
        CGEraser(point1, point2);
    }
}

public class Sprays_v2 implements Shape {
    ArrayList<Vector3> points = new ArrayList<Vector3>();
    color currentColor;
    float sprayRadius = 20; // Default radius
    int sprayDensity = 50; // Default density

    public Sprays_v2(ArrayList<Vector3> p, color c, float sR, int sD) {
        points = p;
        currentColor = c;
        sprayRadius = sR;
        sprayDensity = sD;
    }

    @Override
    public void drawShape() {
        if (points.size() <= 1)
            return;
        for (int i = 0; i < points.size(); i++) {
            Vector3 p = points.get(i);
            drawPoint(p.x, p.y, currentColor);
        }
    }
}


public class Sprays implements Shape {
    Vector3 point = new Vector3();
    color currentColor;
    float sprayRadius = 20; // Default radius
    int sprayDensity = 50; // Default density

    public Sprays(Vector3 p, color c, float sR, int sD) {
        point = p;
        currentColor = c;
        sprayRadius = sR;
        sprayDensity = sD;
    }

    @Override
    public void drawShape() {
        CGSprays(point.x, point.y, sprayRadius, sprayDensity, currentColor);
    }
}