class Graph {

  int cursorX = width/2;
  int cursorSize = 20;
  int cursorWeight = 2;
  int cursorColor = 255;

  float[] graphLength = new float[cursorX];
  int graphColor = 255;
  int graphWeight = 3;
  int graphSpeed = 5;
  
  int textColor = 255;

  Graph() {
    for (int i = 0; i < graphLength.length; i++) {
      graphLength[i] = height/2;
    }
  }

  void activate() {
    circle();
    printTB();
    plotGraph();
  }

  void circle() {
    //if(displayPos < height/2) cursorColor = 0;
    //else cursorColor = 255;
    cursorColor = 255;
    stroke(cursorColor);
    noFill();
    strokeWeight(cursorWeight);
    ellipse(cursorX, displayPos, cursorSize, cursorSize);
  }
  
  void printTB(){
    fill(cursorColor);
    textSize(10);
    textAlign(LEFT, CENTER);
    text(tbVal, cursorX + 15, displayPos);
  }

  void plotGraph() {
    strokeWeight(graphWeight);
    stroke(graphColor);
    graphLength[0] = displayPos;
    
    noFill();
    beginShape();
    //vertex(cursorX, mouseY);
    point(cursorX - graphSpeed, graphLength[0]);
    for (int i = graphLength.length-1; i > 0; i--) {
      graphLength[i] = graphLength[i - 1];
      vertex(cursorX - i * graphSpeed, graphLength[i]);
      //line(cursorX - i * graphSpeed, graphLength[i], cursorX - (i + 1) * graphSpeed, graphLength[i - 1]);
    }
    endShape();
  }
}