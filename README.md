# HW3
## Tasks
### FUNDAMENTAL

- [X] (40%) Correctly implement the 2 rotation matrices.
- [X] (20%) Correctly implement depth buffer.
- [X] (20%) Correctly implement camera control.
- [X] (20%) Correctly implement backculling.

### BONUS 

- [ ] [+1.5 Semester Score] Successfully implement 3D Clipping

### screenshots & how I completed these tasks
### STANDARD
#### (40%) Correctly implement the 2 rotation matrices.
The rotation matrix for a 3D transformation is defined as follows:

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW2/images/rotation_m.png)

I assign the values to the corresponding matrices.

![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW3/images/rotationMatrix.gif)

The `localToWorld()` function first moves the object using `transform.position`, rotates it along the Z, X, and Y axes, and then scales it based on `transform.scale`. The resulting matrix transforms the object from local coordinates to world coordinates.

function:
```
Matrix4::makeRotX(float a)
Matrix4::makeRotY(float a)
GameObject::localToWorld()
```
#### (20%) Correctly implement depth buffer.

I computes the depth (z-coordinate) of a point $(x, y)$ within a triangle defined by three vertices `vertex[0]`, `vertex[1]`, and `vertex[2]`.

1. **Vertex Initialization**:  
   The three vertices of the triangle are extracted into `v0`, `v1`, and `v2`, representing the points in 3D space.

2. **Edge Vectors Calculation**:  
   Two edges of the triangle are calculated:
   `v0v1 = v1 - v0` and `v0v2 = v2 - v0`, which describe the sides of the triangle from `v0` to the other two vertices.

3. **Normal Vector Calculation**:  
   The plane's normal vector `n = v0v1 X v0v2` is perpendicular to the plane containing the triangle.

4. **Plane Equation Setup**:  
   The plane equation in 3D space is:  
   $   n_x \cdot x + n_y \cdot y + n_z \cdot z + d = 0$
   
   The constant \(d\) is computed by substituting one of the vertices (here is `v0`) into the plane equation:  `d = - (n * v0)`

5. **Solving for Depth \(z\)**:  
   Rearrange the plane equation to isolate \(z\):  
   $
   z = \frac{-(n_x \cdot x + n_y \cdot y + d)}{n_z}
   $
   which calculates the z-coordinate based on the provided `x`, `y`, and the triangle's plane parameters.

6. **Return the Result**:  
   The computed depth \(z\) is returned.
   
#### (20%) Correctly implement camera control.
I implements camera movement control using boolean flags triggered by keyboard and mouse input. When arrow keys are pressed, corresponding boolean flags (upPressed, downPressed, leftPressed, rightPressed) are set to true, moving the camera along the x and y axes. Releasing the keys resets the flags. The mouseWheel function adjusts the camera's z-position based on the scroll amount, enabling zoom in/out. The camera's position and orientation are updated using `main_camera.setPositionOrientation(cam_position, lookat)` in `cameraControl()`.
![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW3/images/cameraControl.gif)
#### (20%) Correctly implement backculling.
`debugDraw()` renders a mesh's triangles in screen space using a camera's view-projection matrix. Each triangle's vertices are transformed using the Model-View-Projection (MVP) matrix, homogenized, and mapped to screen coordinates. The triangle's normal vector is computed using the cross product of two edges. If the dot product between the normal and the camera's view vector is negative, the triangle faces the camera and its edges are drawn using `CGLine()`.
![image](https://github.com/t1ao20/Computer_Graphics_HW/blob/HW3/images/backculling.png)
```
GameObject::debugDraw()
```
