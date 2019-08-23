float Gravity = -30;
float MaxYVelocity = 11;
float XVelocity = 3f;

int Gridsize = 60;
float BirdDiameter = 0.8f;
float birdscreenoffsetx = 3;

float Groundheight = 2;

float PipeWidth = 1.5f;
float PipeHeight = 9.25f;

boolean ai = true;
boolean shownetwork = true;
int networkwidth = 400;
int networkheight = 400;
int birdcount = 500;
NetworkVisualizer nv;
Bird currentbirdtovisualize;

Level level;
PipePair testpipes;

PImage Bird;
PImage UpperPipe;
PImage LowerPipe;
PImage Background;
PImage Ground;

long time;
Key jump;

PFont Font;

void setup()
{
  size(1280, 720, P2D);
  level = new Level();
  jump = new Key();
  testpipes = new PipePair(new PVector(3, 8f));
  time = millis();
  Bird = loadImage(sketchPath() + "/Bird.png");
  UpperPipe = loadImage(sketchPath() + "/UpperPipe.png");
  LowerPipe = loadImage(sketchPath() + "/LowerPipe.png");
  Background = loadImage(sketchPath() + "/Background.png");
  Ground = loadImage(sketchPath() + "/Ground.png");
  Font = createFont("Liberation Sans", 16, true);
}

float clamp(float value, float min, float max)
{
  if(value <= min)
  {
    return min;
  }
  else if(value >= max)
  {
    return max;
  }
  else
  {
    return value;  
  }
}

void mousePressed()
{
  jump.Toggle(true);
}

void draw()
{
  background(55);
  if(level.AllBirdsDead())
  {
    if(ai || (!ai && jump.IsDown))
    {
      level.Reset(false);
    }
    
    currentbirdtovisualize = null;
  }
  
  level.Update(millis() - time);
  
  pushMatrix();
  DrawBackground();
  translate(Gridsize * (birdscreenoffsetx - level.GetFirstBirdXPosition()), -Groundheight * Gridsize + height);
  scale(Gridsize);
  strokeWeight(2/(float)Gridsize);
  level.Draw();
  popMatrix();
  DrawGround();
  DrawScore();
  
  if(ai)
  {
    if(jump.IsDown)
    {
      shownetwork = !shownetwork;
    }
    
    DrawAIInfo();
  }
  
  jump.Toggle(false);
  time = millis();
}

void DrawBackground()
{
  image(Background, width/2, height/2, width, height);
}

void DrawGround()
{
  image(Ground, width/2, height - Groundheight * Gridsize / 2, width, Groundheight * Gridsize);
}

void DrawScore()
{
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Score: " + (int)level.Score, width / 2, height * 0.1f);
}

void DrawAIInfo()
{
  if(shownetwork)
  {
    if(currentbirdtovisualize == null || !currentbirdtovisualize.Alive)
    {
      currentbirdtovisualize = level.GetFirstActiveBird();
      nv = new NetworkVisualizer(currentbirdtovisualize.DNA, networkwidth, networkheight);
    }
    
    textSize(18);
    pushMatrix();
    translate(width/2, height/2);
    nv.Draw();
    popMatrix();
  }
  
  textSize(23);
  textAlign(CORNER, CORNER);
  text("Populationsize: " + level.Population.GetPopulationsize() + "\nCurrent Generation: " + level.Population.GetCurrentgeneration(), 20, height * 0.93f);
}
