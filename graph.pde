import processing.serial.*;

Serial myPort;
int xPos = 1;
float height_old = 0;
float height_new = 0;
float inByte = 0;


void setup() {
    size(1000, 400);
    surface.setTitle("ECG Graph");
    println(Serial.list());
    myPort = new Serial(this, Serial.list()[2], 9600);
    myPort.bufferUntil('\n');
    background(0xff);
}


void draw() {
    
}


void serialEvent(Serial myPort) {
    String inString = myPort.readStringUntil('\n');
    
    if (inString != null) {
        inString = trim(inString);
        if (inString.equals("!")) { 
            stroke(0, 0, 0xff);
            inByte = 512;
        }
        else{
            stroke(0xff, 0, 0);
            inByte = float(inString); 
        }
        
        inByte = map(inByte, 0, 1023, 0, height);
        height_new = height - inByte; 
        line(xPos - 1, height_old, xPos, height_new);
        height_old = height_new;
        
        if (xPos >= width) {
            xPos = 0;
            background(0xff);
        } 
        else {
            xPos++;
        }
        
    }
    }
