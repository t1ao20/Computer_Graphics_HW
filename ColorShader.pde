public class PhongVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector4[][] result = { gl_Position, w_position, w_normal };

        return result;
    }
}

public class PhongFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 w_position = (Vector3) varying[1];
        Vector3 w_normal = (Vector3) varying[2];
        Vector3 albedo = (Vector3) varying[3];      //反照率(Albedo)
        Vector3 kdksm = (Vector3) varying[4];       //漫反射係數（Kd）、鏡面反射係數（Ks）、高光指數（m）
        Light light = basic_light;
        Camera cam = main_camera;

        // TODO HW4
        // In this section, we have passed in all the variables you need.
        // Please use these variables to calculate the result of Phong shading
        // for that point and return it to GameObject for rendering

        Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);

        Vector3 light_dir = light.transform.position.sub(w_position);
        light_dir.normalize();
        Vector3 diffuse = light.light_color.mult(kdksm.x()).mult(Math.max(Vector3.dot(w_normal.unit_vector(), light_dir), 0.0f));
        Vector3 surfaceColor = albedo.product(ambient.add(diffuse));

        Vector3 viewDir = cam.transform.position.sub(w_position);
        viewDir.normalize();

        Vector3 h = light.transform.position.add(cam.transform.position);
        h.normalize();

        Vector3 specular = light.light_color.mult(kdksm.y()).mult((float)Math.pow(Math.max(Vector3.dot(h, w_normal.unit_vector()), 0.0), kdksm.z()));

        Vector3 illuminate = surfaceColor.add(specular);

        // return color + Alpha
        return new Vector4(illuminate.x(), illuminate.y(), illuminate.z(), 1.0);
    }
}

public class FlatVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.

        Vector3[] aVertexPosition = (Vector3[]) attribute[0];   //頂點位置
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector3 centroid = aVertexPosition[0].add(aVertexPosition[1]).add(aVertexPosition[2]).dive(3.0f);  //三角形中心
        Vector3 w_centroid = M.mult(centroid.getVector4(1.0f)).xyz();   //轉換到 world space

        Vector3 edge0 = aVertexPosition[1].sub(aVertexPosition[0]);
        Vector3 edge1 = aVertexPosition[2].sub(aVertexPosition[0]);
        Vector3 faceNormal = Vector3.cross(edge0, edge1);
        faceNormal.normalize();

        //to world space
        Vector3 w_normal = M.mult(faceNormal.getVector4(0.0f)).xyz();
        w_normal.normalize();

        Vector4[] gl_Position = new Vector4[aVertexPosition.length];
        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0f));
        }

        Vector4[] res_centroid = new Vector4[]{w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f)};
        Vector4[] res_normal = new Vector4[]{w_normal.getVector4(0.0f), w_normal.getVector4(0.0f), w_normal.getVector4(0.0f)};
        Vector4[][] result = {gl_Position, res_centroid, res_normal};
        
        return result;

    }
}

public class FlatFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        Vector3 w_centroid = (Vector3) varying[1];
        Vector3 normal = (Vector3) varying[2]; 
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;

        Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);

        Vector3 light_dir = light.transform.position.sub(w_centroid);
        light_dir.normalize();
        Vector3 diffuse = light.light_color.mult(Math.max(Vector3.dot(normal, light_dir), 0.0f)).product(albedo);

        Vector3 resColor = ambient.add(diffuse);

        return new Vector4(resColor.x(), resColor.y(), resColor.z(), 1.0f);
    }
}

public class GouraudVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector3 Ka = (Vector3)uniform[2];
        float Kd = (Float)uniform[3];
        Vector3 albedo = (Vector3)uniform[4];
        Light light = basic_light;

        Vector4[] gl_Position = new Vector4[3];
        Vector4[] vertex_color = new Vector4[3];

        for (int i = 0; i < aVertexPosition.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            Vector3 worldPos = M.mult(aVertexPosition[i].getVector4(1.0)).xyz();
            Vector3 w_normal = M.mult(aVertexNormal[i].getVector4(0.0)).xyz();
            w_normal.normalize();

            Vector3 ambient = Ka.product(albedo);
            Vector3 light_dir = light.transform.position.sub(worldPos);
            light_dir.normalize();
            float diffuse_Intensity = Math.max(Vector3.dot(w_normal, light_dir), 0.0f);
            Vector3 diffuse = albedo.product(light.light_color).mult(diffuse_Intensity * Kd);

            Vector3 resLight = ambient.add(diffuse);
            vertex_color[i] = resLight.getVector4(1.0);
        }

        return new Vector4[][]{gl_Position, vertex_color};

        
    }
}

public class GouraudFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {

        // TODO HW4
        // Here you have to complete Gouraud shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note : In the fragment shader, the first 'varying' variable must be its
        // screen position.
        // Subsequent variables will be received in order from the vertex shader.
        // Additional variables needed will be passed by the material later.

        // return interpolated color
        return (Vector4) varying[0];
    }
}
