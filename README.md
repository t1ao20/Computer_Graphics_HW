# CG HW 2 Report
## Completed Task
### STANDARD
- [X] (20%) Correctly implement the 3 transformation matrices.
- [X] (25%) Correctly implement pnpoly.
- [X] (20%) Correctly implement the bounding box.
- [X] (35%) Correctly implement Sutherland Hodgman Algorithm.
### BONUS 
- [ ] [+1.5 Semester Score] Successfully implement SSAA.
      
## screenshots & how I completed these tasks
### (20%) Correctly implement the 3 transformation matrices.
#### 1. Translation matrix

The translation matrix for a 3D transformation is defined as follows:

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/translation_m.png)


so I just assign `t.x`, `t.y`, `t.z` to `m[3]`, `m[7]`, `m[11]` respectively.

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/pos.gif)

function:

```
Matrix4::makeTrans(Vector3 t)
```
#### 2. Scaling Matrix
The scaling matrix for a 3D transformation is defined as follows:

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/scaling_m.png)

so I just assign `s.x`, `s.y`, `s.z` to `m[0]`, `m[5]`, `m[10]` respectively.

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/scale.gif)

function:

```
Matrix4::makeScale(Vector3 s)
```
#### 3. Rotation Matrix
The rotation matrix for a 3D transformation is defined as follows:

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/rotation_m.png)

I assign the values to the corresponding matrices.

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/rotate.gif)

function:
```
Matrix4::makeRotX(float a)
Matrix4::makeRotY(float a)
Matrix4::makeRotZ(float a)
```
### (25%) Correctly implement pnpoly.

[Ref](https://www.youtube.com/watch?v=RSXM9bgqxJM)

`pnpoly` is an implementation of the **point-in-polygon** algorithm.

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/pnpoly.png)

The function uses a `ray-casting approach`. It "casts" a ray horizontally from the test point $(x, y)$ and counts how many times this ray intersects the polygon's edges. For each edge, defined by two consecutive vertices, it checks whether this edge intersects the horizontal line passing through the test point.

**Conditions for Intersection:**

   - For an edge defined by two vertices $(x_i, y_i)$ and $(x_j, y_j)$:

     - **Condition 1**: Check if the y of the test point is between $y_i$ and $y_j$. This ensures that the point lies within the vertical range of the edge.

     - **Condition 2**: Calculate `x_cross` where the line through this edge would intersect a horizontal line at $y$. If the x-coordinate of the test point is less than `x_cross`, the ray from the point crosses this edge.

- If both conditions are true, it increments `intercount`, which keeps track of the number of intersections.
- After counting intersections for all edges, checks if `intercount` is odd or even.
   - If the count is odd, the point is inside the polygon (return `true`); if even, it’s outside (return `false`).

function:
```
util::pnpoly(float x, float y, Vector3[] vertexes)
```
### (20%) Correctly implement the bounding box.
I calculates the smallest box that fully contains all given 3D points by finding the minimum and maximum $x$, $y$, and $z$ values among them, then returns these values as two opposite corners of the bounding box.

function:
```
util::findBoundBox(Vector3[] v) 
```
### (35%) Correctly implement Sutherland Hodgman Algorithm.
**Sutherland-Hodgman Algorithm** is used for polygon clipping—finding the portion of a polygon that lies within a specific boundary.

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/Sutherland_Hodgman.png)

1. **Initial Setup**: 
   - The input polygon vertices (`points`) are loaded into an `input` list.
   - The function iterates over each edge of the clipping boundary.

2. **Clipping Against Each Edge**:
   - For each boundary edge, it iterates through all edges of the polygon defined by `input`.
   - For each polygon edge, it checks whether the endpoints are inside or outside the boundary edge using `checkPointInside`.
   
3. **Determining Output Points**:
   - If the start of the polygon edge is inside the boundary and the end is outside, it adds the intersection point where the edge crosses the boundary.
   - If both are inside, it keeps the end of the edge in the output.
   - If the start is outside and the end is inside, it adds both the intersection point and the end point to the output.
   
4. **Update for Each Edge**:
   - `output` becomes the new `input` for the next boundary edge, progressively clipping the polygon.

5. **Result**:
   - After clipping against all boundary edges, the final `output` list contains the vertices of the clipped polygon, which is returned as an array.

function:
```
util::Sutherland_Hodgman_algorithm(Vector3[] points,Vector3[] boundary)
```
The helper functions:
- `checkPointInside`: determines if a point is inside a boundary edge.
    - by using a cross-product method.
    - It calculates vectors for the boundary (from `edgeStart` to `edgeEnd`) and for the point being checked (`checkPoint` relative to `edgeStart`). By taking the cross product of these two vectors, checks the relative orientation between them.
    - If the result of the cross product is less than or equal to zero, this means that `checkPoint` lies on the "inside" side of the edge (or directly on it) -> returns `true`.
    - If the cross product is positive, the point is outside -> returns `false`.
- `findIntersection` calculates where a polygon edge intersects the boundary edge.
    - It calculates the intersection point between two line segments:
        - one defined by `edgeStart` and `edgeEnd`
        - the other defined by `p1` and `p2`. 
    - It uses the parametric form of line equations and solves for the parameter `t`, which represents where the intersection occurs along the edge. The function computes the cross product of the direction vectors of the two lines to find `t`, and then calculates the coordinates of the intersection point using this value. The resulting intersection point is returned as a new `Vector3`, with the `z` coordinate set to 0.

### [+1.5 Semester Score] Successfully implement SSAA.
