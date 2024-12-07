public class Camera {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.
        float verticalScale = 1.0f / tan(GH_FOV * 2 * PI / 360.0f);
        float aspectRatio = float(hei) / float(wid);
        float depthRange = near - far;

        projection = Matrix4.Identity();
        projection.m[5] = aspectRatio;
        projection.m[10] = far / -depthRange * (1/verticalScale);
        projection.m[11] = (near * far) / depthRange * (1/verticalScale);
        projection.m[14] = 1/verticalScale;
        projection.m[15] = 0.0f;

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {

    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.

        Matrix4 T = Matrix4.Trans(pos.mult(-1));
        Vector3 viewVec = lookat.sub(pos).unit_vector();
        Vector3 topVec = new Vector3(0, 1, 0);

        Vector3 rightVec = Vector3.cross(viewVec, topVec).unit_vector();
        Vector3 upVec = Vector3.cross(rightVec, viewVec).unit_vector();

        Matrix4 GRM = Matrix4.Identity();
        GRM.m[0] = rightVec.x;   GRM.m[1] = rightVec.y;   GRM.m[2]  = rightVec.z;
        GRM.m[4] = upVec.x;      GRM.m[5] = upVec.y;      GRM.m[6]  = upVec.z;
        GRM.m[8] = viewVec.x;    GRM.m[9] = viewVec.y;    GRM.m[10] = viewVec.z;

        worldView = GRM.mult(T);
    }
}
