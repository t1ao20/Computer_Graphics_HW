import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;

void setup() {
    size(1000, 600);
    renderer_size = new Vector4(20, 50, 520, 550);
    cam_position = new Vector3(0, 0, -10);
    lookat = new Vector3(0, 0, 0);
    setDepthBuffer();
    main_camera = new Camera();
    engine = new Engine();

}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw() {
    background(255);

    engine.run();
    cameraControl();
}

String selectFile() {
    JFileChooser fileChooser = new JFileChooser();
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}

// void cameraControl(){
//     // You can write your own camera control function here.
//     // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
//     // Hint : Use keyboard event and mouse click event to change the position of the camera.       
        
//     // main_camera.setPositionOrientation(cam_position, new Vector3(0,0,1));
//     keyPressed();

// }

// 根據布林變數來移動相機
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

void cameraControl() {
  if (upPressed)    cam_position.y += 0.5;
  if (downPressed)  cam_position.y -= 0.5;
  if (leftPressed)  cam_position.x -= 0.5;
  if (rightPressed) cam_position.x += 0.5;

  // 設定相機位置與目標點
  main_camera.setPositionOrientation(cam_position,lookat);  
}

// 當按鍵被按下時設置布林變數
void keyPressed() {
  if (keyCode == UP) upPressed = true;
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
}

// 當按鍵被釋放時重置布林變數
void keyReleased() {
  if (keyCode == UP) upPressed = false;
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
}

// 處理滑鼠滾輪事件
void mouseWheel(MouseEvent event) {
  float e = event.getCount();  // 獲取滾輪的滾動量
  cam_position.z += e * 0.5;    // 改變相機 Z 軸位置 (縮放效果)
}