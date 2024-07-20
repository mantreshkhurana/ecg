import processing.serial.*;
import processing.pdf.*;

Serial myPort;
int xPos = 1;
float height_old = 0;
float height_new = 0;
float inByte = 0;
ArrayList<Float> ecgData = new ArrayList<Float>();
boolean recording = false;

void setup() {
    size(1000, 400);
    surface.setTitle("ECG Graph");
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[2], 9600);
    myPort.bufferUntil('\n');
    background(0xff);
    drawGrid();
}

void draw() {
    if (recording) {
        beginRecord(PDF, "ECG_data.pdf");
        drawGrid();
        for (int i = 1; i < ecgData.size(); i++) {
            float previousValue = map(ecgData.get(i - 1), 0, 1023, height, 0);
            float currentValue = map(ecgData.get(i), 0, 1023, height, 0);
            line(i - 1, previousValue, i, currentValue);
        }
        endRecord();
        recording = false;
        println("Data saved as PDF");
    }
}

void serialEvent(Serial myPort) {
    String inString = myPort.readStringUntil('\n');
    
    if (inString != null) {
        inString = trim(inString);
        if (inString.equals("!")) { 
            stroke(0, 0, 0xff);
            inByte = 512;
        } else {
            stroke(0xff, 0, 0);
            try {
                inByte = float(inString);
                ecgData.add(inByte);
                detectHealthIssues(inByte);
            } catch (NumberFormatException e) {
                println("Error: " + e.getMessage());
                return;
            }
        }
        
        inByte = map(inByte, 0, 1023, 0, height);
        height_new = height - inByte;
        line(xPos - 1, height_old, xPos, height_new);
        height_old = height_new;
        
        if (xPos >= width) {
            xPos = 0;
            background(0xff);
            drawGrid();
        } else {
            xPos++;
        }
    }
}

void drawGrid() {
    stroke(200);
    for (int i = 0; i < width; i += 50) {
        line(i, 0, i, height);
    }
    for (int j = 0; j < height; j += 50) {
        line(0, j, width, j);
    }
    fill(0);
    textSize(12);
    text("Time (ms)", width / 2 - 30, height - 10);
    text("ECG", 10, 20);
}

void keyPressed() {
    if (key == 'r' || key == 'R') {
        xPos = 0;
        background(0xff);
        drawGrid();
    }
    if (key == 's' || key == 'S') {
        recording = true;
    }
}

void detectHealthIssues(float ecgValue) {
    // Example detection logic for anomalies
    if (ecgValue > 900) {
        println("Warning: High ECG value detected!");
    } else if (ecgValue < 100) {
        println("Warning: Low ECG value detected!");
    }
}
