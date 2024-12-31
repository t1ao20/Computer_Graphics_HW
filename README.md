# HW3
## Tasks
### FUNDAMENTAL

- [X] (25%) Correctly implement the barycentric.
- [X] (25%) Correctly implement Phong Shading.
- [X] (25%) Correctly implement Flat Shading.
- [X] (25%) Correctly implement Gouraud Shading.

## screenshots & how I completed these tasks
### STANDARD
#### (25%) Correctly implement the barycentric.

1. Function:
```java=
util::barycentric(Vector3 P, Vector4[] verts)
```
2. Description

- First, each vertex in the `verts` array is a 4D vector (`Vector4`). `homogenized()` function converts these 4D vertices into 3D points by dividing the $ x, y, z $  by the $ w $. This gives $ A, B, C $, the triangle vertices in 3D space.

- Second, calculates three vectors:
    - $ v0 = B - A $: Vector from $ A $ to $ B $.
    - $ v1 = C - A $: Vector from $ A $ to $ C $.
    - $ v2 = P - A $: Vector from $ A $ to $ P $.

- Third, dot products:
    - $ d00 = \text{dot}(v0, v0) $: Length squared of $ v0 $.
    - $ d01 = \text{dot}(v0, v1) $: Dot product between $ v0 $ and $ v1 $.
    - $ d11 = \text{dot}(v1, v1) $: Length squared of $ v1 $.
    - $ d20 = \text{dot}(v2, v0) $: Dot product between $ v2 $ and $ v0 $.
    - $ d21 = \text{dot}(v2, v1) $: Dot product between $ v2 $ and $ v1 $.

- Forth, the barycentric coordinates $( \beta $, $ \gamma $, $ \alpha )$ are computed using the formula:
    $
    \beta = \frac{d_{11}d_{20} - d_{01}d_{21}}{\text{denom}}, \quad
    \gamma = \frac{d_{00}d_{21} - d_{01}d_{20}}{\text{denom}}, \quad
    \alpha = 1 - \beta - \gamma
    $
- Here, `denom` is the determinant of a matrix formed by $ v0 $ and $ v1 $, ensuring the calculations are normalized.

- Fifth, barycentric coordinates are modified to account for perspective correction:
    - Each coordinate is multiplied by the corresponding vertex's $(w)$ component:
    $
    \alpha' = \alpha \cdot A.w, \quad
    \beta' = \beta \cdot B.w, \quad
    \gamma' = \gamma \cdot C.w
    $
    - The coordinates are then normalized so their sum is `1`:
    $
    \alpha = \frac{\alpha'}{\text{sum}}, \quad
    \beta = \frac{\beta'}{\text{sum}}, \quad
    \gamma = \frac{\gamma'}{\text{sum}}
    $

- Sixth, the final normalized barycentric coordinates $ (\alpha, \beta, \gamma )$ are returned as a float array.

In standard barycentric interpolation, the coordinates are linearly interpolated in screen space. However, in perspective projection, this leads to incorrect results because interpolation should consider the depth of each vertex (stored in the $ w $ component). Multiplying by $ w $ ensures that interpolation respects perspective distortion, and normalizing ensures the coordinates remain consistent.

---

#### (25%) Correctly implement Phong Shading.
1. Function:
```java=
Material::PhongMaterial
ColorShader::PhongVertexShader
ColorShader::PhongFragmentShader
```
2. Description

##### 1. **Parameters**
- **`w_position`**: The world position of the current fragment (pixel) being shaded.
- **`w_normal`**: The normal vector at the fragment, which determines how light interacts with the surface at this point.
- **`albedo`**: The base color of the material, which defines how the surface reflects diffuse light.
- **`kdksm`**: A vector containing:
  - `kd` (diffuse reflection coefficient),
  - `ks` (specular reflection coefficient),
  - `m` (shininess exponent, controlling the sharpness of specular highlights).
- **`light` and `cam`**: The light source and camera objects, representing their properties and positions in the scene.
##### **2. Ambient Light Calculation**
Ambient light is the general illumination in the scene, not coming from any specific light source. It is calculated as:

```java
Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);
```
##### **3. Diffuse Reflection Calculation**
Diffuse reflection is light scattered in all directions from a rough surface. It depends on the angle between the surface normal and the light direction. Calculated as:
```java
Vector3 light_dir = light.transform.position.sub(w_position);
light_dir.normalize();

Vector3 diffuse = light.light_color.mult(kdksm.x()).mult(Math.max(Vector3.dot(w_normal.unit_vector(), light_dir), 0.0f));
```
##### **4. Surface Color (`surfaceColor`)**
The combined contribution of ambient and diffuse light to the fragment's color is calculated as:

```java
Vector3 surfaceColor = albedo.product(ambient.add(diffuse));
```

##### **5. Specular Reflection Calculation**
Specular reflection represents the shiny highlights on a surface, which depend on the viewer's perspective. It is calculated as:

```java
Vector3 viewDir = cam.transform.position.sub(w_position);
viewDir.normalize();

Vector3 h = light.transform.position.add(cam.transform.position);
h.normalize();

Vector3 specular = light.light_color.mult(kdksm.y()).mult((float)Math.pow(Math.max(Vector3.dot(h, w_normal.unit_vector()), 0.0), kdksm.z()));
```

##### **6. Combining Results**
The total illumination at the fragment is the sum of the ambient, diffuse, and specular contributions:

```java
Vector3 illuminate = surfaceColor.add(specular);
```

##### **7. Output Color**
The final color is returned as a `Vector4`, including an alpha value (`1.0`, fully opaque):

```java
return new Vector4(illuminate.x(), illuminate.y(), illuminate.z(), 1.0);
```

---

#### (25%) Correctly implement Flat Shading.
1. Function:
```
Material::FlatMaterial
ColorShader::FlatVertexShader
ColorShader::FlatFragmentShader
```
2. Description
```
1. FlatVertexShader
```

##### 1. **Inputs**: 
   - Vertex positions (`aVertexPosition`) from attributes.
   - Transformation matrices (`MVP` for Model-View-Projection, and `M` for world space transformation) from uniforms.
```java=
Vector3[] aVertexPosition = (Vector3[]) attribute[0];   //頂點位置
Matrix4 MVP = (Matrix4) uniform[0];
Matrix4 M = (Matrix4) uniform[1];
```
##### 2. **Centroid and Face Normal**:
   - Computes the triangle's **centroid** (geometric center) and transforms it to world space (`w_centroid`).
```java
Vector3 centroid = aVertexPosition[0].add(aVertexPosition[1]).add(aVertexPosition[2]).dive(3.0f);
Vector3 w_centroid = M.mult(centroid.getVector4(1.0f)).xyz();
```
   - Computes the triangle's **face normal** by taking the cross product of two triangle edges and normalizing it.
```java
Vector3 edge0 = aVertexPosition[1].sub(aVertexPosition[0]);
Vector3 edge1 = aVertexPosition[2].sub(aVertexPosition[0]);
Vector3 faceNormal = Vector3.cross(edge0, edge1);
faceNormal.normalize();

Vector3 w_normal = M.mult(faceNormal.getVector4(0.0f)).xyz();
w_normal.normalize();
```
##### 3. **Transform Vertices**:
   - Transforms each vertex position into clip space using the `MVP` matrix.
```java
Vector4[] gl_Position = new Vector4[aVertexPosition.length];
        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0f));
        }
```
##### 4. **Outputs**:
   - Passes the transformed vertex positions, the centroid (duplicated for all vertices), and the face normal (duplicated for all vertices) to the fragment shader for consistent flat shading across the triangle.
```java
Vector4[] res_centroid = new Vector4[]{w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f)};
Vector4[] res_normal = new Vector4[]{w_normal.getVector4(0.0f), w_normal.getVector4(0.0f), w_normal.getVector4(0.0f)};
Vector4[][] result = {gl_Position, res_centroid, res_normal};

return result;
```
---
```
2. FlatFragmentShader
```
##### **1. Inputs**
The fragment shader receives `varying` inputs passed from the vertex shader:
- **`w_centroid`**: The world-space position of the triangle's centroid.
- **`normal`**: The face normal vector (constant across the triangle).
- **`albedo`**: The material's base color.
- **`kdksm`**: Coefficients for diffuse reflection (`kd`), specular reflection (`ks`), and shininess (`m`).
- **`light`** and **`cam`**: The light source and camera for shading calculations.

```java
Vector3 w_centroid = (Vector3) varying[1];
Vector3 normal = (Vector3) varying[2]; 
Vector3 albedo = (Vector3) varying[3];
Vector3 kdksm = (Vector3) varying[4];
Light light = basic_light;
Camera cam = main_camera;
```


##### **2. Ambient Light Calculation**

- **Formula**: `ambient = light.color × AMBIENT_LIGHT × albedo`

```java
Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);
```

##### **3. Diffuse Reflection Calculation**


- **Light Direction**: Direction from the centroid to the light source.
- **Formula**: `diffuse = light.color × max(dot(normal, light_dir), 0) × albedo`

```java
Vector3 light_dir = light.transform.position.sub(w_centroid);
light_dir.normalize();
Vector3 diffuse = light.light_color.mult(Math.max(Vector3.dot(normal, light_dir), 0.0f)).product(albedo);
```

##### **4. Combine Ambient and Diffuse**
The total light contribution is the sum of ambient and diffuse components.

```java
Vector3 resColor = ambient.add(diffuse);
```


##### **5. Output Final Color**
Return the final color as a `Vector4`, including an alpha value of `1.0f` for full opacity:

```java
return new Vector4(resColor.x(), resColor.y(), resColor.z(), 1.0f);
```
---
#### (25%) Correctly implement Gouraud Shading.
1. Function:
```
Material::GouraudMaterial
ColorShader::GouraudVertexShader
ColorShader::GouraudFragmentShader
```
2. Description

```
ColorShader::GouraudVertexShader
```
This code implements **Gouraud shading** in the vertex shader, calculating lighting (ambient and diffuse) per vertex. The resulting vertex color is interpolated across the triangle during rasterization. Here's a breakdown of the code:

---

##### **1. Parameters**

- **`aVertexPosition`**: Vertex positions.
- **`aVertexNormal`**: Vertex normals.
- **`MVP`**: Model-View-Projection matrix.
- **`M`**: World transformation matrix.
- **`Ka`**: Ambient reflection coefficient.
- **`Kd`**: Diffuse reflection coefficient.
- **`albedo`**: Base material color.
- **`light`**: Light source properties.

```java
Vector3[] aVertexPosition = (Vector3[]) attribute[0];
Vector3[] aVertexNormal = (Vector3[]) attribute[1];
Matrix4 MVP = (Matrix4) uniform[0];
Matrix4 M = (Matrix4) uniform[1];
Vector3 Ka = (Vector3)uniform[2];
float Kd = (Float)uniform[3];
Vector3 albedo = (Vector3)uniform[4];
Light light = basic_light;
```

##### **2. Initialize Outputs**
- **`gl_Position`**: Transformed vertex positions.
- **`vertex_color`**: Colors of each vertex after applying lighting calculations.

```java
Vector4[] gl_Position = new Vector4[3];
Vector4[] vertex_color = new Vector4[3];
```

##### **3. Loop Through Vertices**
For each vertex:
- Transform its position to **clip space** using the `MVP` matrix.
- Transform its position and normal to **world space** using the `M` matrix.
- Normalize the transformed normal vector.

```java
for (int i = 0; i < aVertexPosition.length; i++) {
    gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0)); // Clip space position
    Vector3 worldPos = M.mult(aVertexPosition[i].getVector4(1.0)).xyz(); // World position
    Vector3 w_normal = M.mult(aVertexNormal[i].getVector4(0.0)).xyz();   // World normal
    w_normal.normalize();
```

---

##### **4. Calculate Lighting**
Lighting is computed per vertex using:
1. **Ambient Light**: $ \text{ambient} = \text{Ka} \cdot \text{albedo} $
2. **Diffuse Light**:
   - Light direction: $ \text{light\_dir} = \text{normalize(light.position - worldPos)} $
   - Dot product: $ \cos \theta = \text{max(dot(w\_normal, light\_dir), 0)} $
   - $ \text{diffuse} = \text{albedo} \cdot \text{light.color} \cdot (\cos \theta \cdot Kd) $

```java
    // Ambient light
    Vector3 ambient = Ka.product(albedo);
    
    // Diffuse light
    Vector3 light_dir = light.transform.position.sub(worldPos);
    light_dir.normalize();
    float diffuse_Intensity = Math.max(Vector3.dot(w_normal, light_dir), 0.0f); // Dot product
    Vector3 diffuse = albedo.product(light.light_color).mult(diffuse_Intensity * Kd);
```


##### **5. Combine Lighting**
The total light is the sum of ambient and diffuse components:
- $ \text{resLight} = \text{ambient} + \text{diffuse} $

The result is stored as the vertex color, including an alpha value of `1.0`.

**Code:**
```java
// Combine ambient and diffuse
Vector3 resLight = ambient.add(diffuse);
vertex_color[i] = resLight.getVector4(1.0); // Store the vertex color
}
```


##### **6. Return Outputs**
- **`gl_Position`**: Vertex positions in clip space.
- **`vertex_color`**: Vertex colors for interpolation during rasterization.

```java
return new Vector4[][]{gl_Position, vertex_color};
```