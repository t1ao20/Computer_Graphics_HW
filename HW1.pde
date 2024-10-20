ShapeButton lineButton;
ShapeButton circleButton;
ShapeButton polygonButton;
ShapeButton ellipseButton;
ShapeButton curveButton;
ShapeButton pencilButton;
ShapeButton eraserButton;
ShapeButton spraysButton;

color selectedColor;
// Color Buttons
ShapeButton redButton;
ShapeButton orangeButton;
ShapeButton yellowButton;
ShapeButton greenButton;
ShapeButton blueButton;
ShapeButton purpleButton;

ShapeButton blackButton;
ShapeButton whiteButton;
ShapeButton grayButton;

ShapeButton pinkButton;
ShapeButton brownButton;
ShapeButton anycolorButton;


Button clearButton;

ShapeRenderer shapeRenderer;
ArrayList<ShapeButton> shapeButton;
float eraserSize = 20;

public void setup() {
    size(1000, 800);
    background(255);
    shapeRenderer = new ShapeRenderer();
    initButton();

}

public void draw() {

    background(255);
    for (ShapeButton sb : shapeButton) {
        sb.run(() -> {
            sb.beSelect();
            shapeRenderer.setRenderer(sb.getRendererType());
        });
    }

    clearButton.run(() -> {
        shapeRenderer.clear();
    });
    shapeRenderer.box.show();

    shapeRenderer.run();

}

void resetButton() {
    for (ShapeButton sb : shapeButton) {
        sb.setSelected(false);
    }
}

public void initButton() {
    shapeButton = new ArrayList<ShapeButton>();
    lineButton = new ShapeButton(10, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
        }

        @Override
        public Renderer getRendererType() {
            LineRenderer lr = new LineRenderer();
            lr.setColor(selectedColor);
            return lr;
        }
    };

    lineButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(lineButton);

    circleButton = new ShapeButton(45, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            circle(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2);
        }

        @Override
        public Renderer getRendererType() {
            CircleRenderer cr = new CircleRenderer();
            cr.setColor(selectedColor);
            return cr;
        }
    };
    circleButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(circleButton);

    polygonButton = new ShapeButton(80, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + 2);
            line(pos.x + 2, pos.y + size.y - 2, pos.x + size.x - 2, pos.y + size.y - 2);
            line(pos.x + size.x - 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
            line(pos.x + 2, pos.y + 2, pos.x + 2, pos.y + size.y - 2);
        }

        @Override
        public Renderer getRendererType() {
            PolygonRenderer pr = new PolygonRenderer();
            pr.setColor(selectedColor);
            return pr;
        }

    };

    polygonButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(polygonButton);

    ellipseButton = new ShapeButton(115, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            ellipse(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2, size.y * 2 / 3);
        }

        @Override
        public Renderer getRendererType() {
            EllipseRenderer er = new EllipseRenderer();
            er.setColor(selectedColor);
            return er;
            // return new EllipseRenderer();
        }

    };

    ellipseButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(ellipseButton);

    curveButton = new ShapeButton(150, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            bezier(pos.x, pos.y, pos.x, pos.y + size.y, pos.x + size.x, pos.y, pos.x + size.x, pos.y + size.y);
        }

        @Override
        public Renderer getRendererType() {
            CurveRenderer cr = new CurveRenderer();
            cr.setColor(selectedColor);
            return cr;
            // return new CurveRenderer();
        }

    };

    curveButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(curveButton);

    clearButton = new Button(width - 50, 10, 30, 30);
    clearButton.setBoxAndClickColor(color(250), color(150));
    clearButton.setImage(loadImage("clear.png"));

    pencilButton = new ShapeButton(185, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            PencilRenderer pr = new PencilRenderer();
            pr.setColor(selectedColor);
            return pr;
            // return new PencilRenderer();
        }
    };
    pencilButton.setImage(loadImage("pencil.png"));

    pencilButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(pencilButton);

    eraserButton = new ShapeButton(220, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            return new EraserRenderer();
        }
    };
    eraserButton.setImage(loadImage("eraser.png"));

    eraserButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(eraserButton);

    spraysButton = new ShapeButton(255, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            return new SpraysRenderer();
        }
    };
    spraysButton.setImage(loadImage("palette.png"));

    spraysButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(spraysButton);

    redButton = new ShapeButton(300,10,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(255,0,0);
            return new colorRenderer();
        }
    };
    redButton.setBoxAndClickColor(color(255,0,0),color(255,50,50));
    shapeButton.add(redButton);

    orangeButton = new ShapeButton(320,10,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(255,165,0);
            return new colorRenderer();
        }
    };
    orangeButton.setBoxAndClickColor(color(255,165,0),color(255,215,0));
    shapeButton.add(orangeButton);

    yellowButton = new ShapeButton(340,10,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(255,255,0);
            return new colorRenderer();
        }
    };
    yellowButton.setBoxAndClickColor(color(255,255,0),color(255,255,50));
    shapeButton.add(yellowButton);

    greenButton = new ShapeButton(360,10,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(0,128,0);
            return new colorRenderer();
        }
    };
    greenButton.setBoxAndClickColor(color(0,128,0),color(50,205,50));
    shapeButton.add(greenButton);

    blueButton = new ShapeButton(380,10,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(0,0,255);
            return new colorRenderer();
        }
    };
    blueButton.setBoxAndClickColor(color(0,0,255),color(50,50,255));
    shapeButton.add(blueButton);

    purpleButton = new ShapeButton(400,10,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(128,0,128);
            return new colorRenderer();
        }
    };
    purpleButton.setBoxAndClickColor(color(128,0,128),color(128,50,128));
    shapeButton.add(purpleButton);

    blackButton = new ShapeButton(300,30,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(0);
            return new colorRenderer();
        }
    };
    blackButton.setBoxAndClickColor(color(0),color(50));
    shapeButton.add(blackButton);

    whiteButton = new ShapeButton(320,30,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(255);
            return new colorRenderer();
        }
    };
    whiteButton.setBoxAndClickColor(color(255),color(205,205,205));
    shapeButton.add(whiteButton);

    grayButton = new ShapeButton(340,30,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(128);
            return new colorRenderer();
        }
    };
    grayButton.setBoxAndClickColor(color(128),color(178));
    shapeButton.add(grayButton);

    pinkButton = new ShapeButton(360,30,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(255,192,203);
            return new colorRenderer();
        }
    };
    pinkButton.setBoxAndClickColor(color(255,192,203),color(255,182,193));
    shapeButton.add(pinkButton);

    brownButton = new ShapeButton(380,30,15,15){
        @Override
        public Renderer getRendererType(){
            selectedColor = color(165,42,42);
            return new colorRenderer();
        }
    };
    brownButton.setBoxAndClickColor(color(165,42,42),color(139,69,19));
    shapeButton.add(brownButton);

    // anycolorButton = new ShapeButton(400,30,15,15){
    //     @Override
    //     public Renderer getRendererType(){
    //         selectedColor = color(165,42,42);
    //         return new colorRenderer();
    //     }
    // };
    // anycolorButton.setBoxAndClickColor(color(165,42,42),color(139,69,19));
    // shapeButton.add(anycolorButton);


}

public void keyPressed() {
    if (key == 'z' || key == 'Z') {
        shapeRenderer.popShape();
    }

}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if (e < 0)
        eraserSize += 1;
    else if (e > 0)
        eraserSize -= 1;
    eraserSize = max(min(eraserSize, 30), 4);
}
