class Bird
{
  PVector Position;
  
  float Angle;
    
  float YVelocity;
  
  boolean Alive;
  boolean HitGround;
  
  boolean IsAIBird;
  Genome DNA;
  Network Brain;
  
  public Bird(PVector position, boolean isaibird, Genome dna)
  {
    this.Position = position;
    this.Alive = true;
    this.HitGround = false;
    this.IsAIBird = isaibird;
    this.DNA = dna;
    this.Brain = new Network(dna);
  }
  
  boolean ShouldJump(Level level)
  {
    if(this.IsAIBird)
    {
      float[] input = new float[5];
      
      input[0] = this.Position.y;
      input[1] = this.YVelocity;
      
      PipePair nextpipe = level.GetFirstRelevantPipe();
      
      input[2] = nextpipe.UpperPipe.Position.y - (nextpipe.UpperPipe.Height / 2);
      input[3] = nextpipe.LowerPipe.Position.y + (nextpipe.LowerPipe.Height / 2);
      input[4] = nextpipe.Position.x - this.Position.x;
      
      float[] output = this.Brain.FeedForward(input);
      
      return output[0] > 0.5f;
    }
    else
    {
      return jump.IsDown;
    }
  }
  
  void Update(long time, Level level)
  {
    if(ShouldJump(level) && this.Alive && this.Position.y <= 10f)
    {
      this.YVelocity = MaxYVelocity;
    }
    
    if(!this.HitGround)
    {
      this.YVelocity = constrain(this.YVelocity + Gravity * time / 1000, -MaxYVelocity, MaxYVelocity);
      this.Position.y += this.YVelocity * time / 1000;
      
      if(this.Alive)
      {
        this.Position.x += XVelocity * time / 1000;
        CheckForCollisions(level);
      }
      
      if(this.Position.y <= 0)
      {
        this.HitGround = true;
        this.Position.y = 0;
        
        if(this.Alive)
        {
          this.Alive = false;
        }
      }
    }
    
    float angletochangeto;
    float lerpspeed;
    
    if(this.YVelocity >= 0)
    {
      angletochangeto = map(this.YVelocity, 0, MaxYVelocity, 0, -PI / 4);
      lerpspeed = 0.9f;
    }
    else
    {
      angletochangeto = map(this.YVelocity, 0, -MaxYVelocity, 0, PI / 2);
      lerpspeed = 0.15f;
    }
    
    this.Angle = lerp(this.Angle, angletochangeto, lerpspeed);
  }
  
  void CheckForCollisions(Level level)
  {
    for(PipePair pp : level.Pipes)
    {
      if(pp.UpperPipe.CheckCircleCollision(this.Position, BirdDiameter / 2) || pp.LowerPipe.CheckCircleCollision(this.Position, BirdDiameter / 2))
      {
        this.Alive = false;
      }
    }
  }
  
  void Draw()
  {
    if(Bird == null)
    {
      if(this.Position != null)
      {
        ellipseMode(CENTER);
        if(this.Alive)
        {
          fill(0, 255, 0);
        }
        else
        {
          fill(255, 0, 0);
        }
        ellipse(Position.x, -Position.y, BirdDiameter, BirdDiameter);
      }
    }
    else
    {
      if(this.Position != null)
      {
        pushMatrix();
        translate(Position.x, -Position.y);
        rotate(this.Angle);
        imageMode(CENTER);
        image(Bird, 0, 0, BirdDiameter * Bird.width / Bird.height, BirdDiameter);
        popMatrix();
      }
    }
  }
}
