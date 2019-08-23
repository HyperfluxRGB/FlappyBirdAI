class Level
{
  ArrayList<PipePair> Pipes;
  ArrayList<Bird> Birds;
  float NextPipeposX;
  
  float Score;
  
  Population Population;
  
  Bird GetFirstBird()
  {
    return Birds.get(0);
  }
  
  Bird GetFirstActiveBird()
  {
    for(Bird bird : this.Birds)
    {
      if(bird.Alive)
      {
        return bird;
      }
    }
    
    return GetFirstBird();
  }
  
  float GetFirstBirdXPosition()
  {
    return GetFirstActiveBird().Position.x;
  }
  
  PipePair GetFirstPipe()
  {
    return Pipes.get(0);
  }
  
  PipePair GetFirstActivePipe()
  {
    PipePair pipe1 = Pipes.get(0);
    PipePair pipe2 = Pipes.get(1);
    
    return pipe1.GainedScore ? pipe2 : pipe1;
  }
  
  PipePair GetClosestPipe()
  {
    Bird firstbird = GetFirstActiveBird();
    
    PipePair pipe1 = Pipes.get(0);
    PipePair pipe2 = Pipes.get(1);
    
    return abs(pipe1.Position.x - firstbird.Position.x) > abs(pipe2.Position.x - firstbird.Position.x) ? pipe2 : pipe1;
  }
  
  PipePair GetFirstRelevantPipe()
  {
    PipePair pipe1 = Pipes.get(0);
    PipePair pipe2 = Pipes.get(1);
    
    return pipe1.Position.x + (PipeWidth / 2) <= GetFirstActiveBird().Position.x - (BirdDiameter / 2) ? pipe2 : pipe1;
  }
  
  float GetFirstPipeXPosition()
  {
    return GetFirstPipe().Position.x;
  }
  
  boolean AllBirdsDead()
  {
    for(Bird bird : this.Birds)
    {
      if(bird.Alive)
      {
        return false;
      }
    }
    
    return true;
  }
  
  void Reset(boolean setup)
  {
    if(setup)
    {
      Genome startgenome = new Genome(5, 1, 5);
      
      for(int i = 1; i <= 5; i++)
      {
        startgenome.AddConnection(new Connection(i, 6, true, i, random(-1, 1)));
      }
      
      Population = new Population(birdcount, startgenome, 3f, 1f, 1f, 0.4f, null);
    }
    else
    {
      if(ai)
      {
        for(Bird bird : this.Birds)
        {
          Population.SetFitness(bird.DNA, bird.Position.x);
        }
        
        Population.NextGeneration(new FlappyBird());
      }
    }
    
    this.Birds = new ArrayList<Bird>();
    this.Pipes = new ArrayList<PipePair>();
    
    if(ai)
    {
      for(int i = 0; i < birdcount; i++)
      {
        this.Birds.add(new Bird(new PVector(-2, 5), true, Population.NextGenome()));
      }
    }
    else
    {
      this.Birds.add(new Bird(new PVector(-2, 5), false, null));
    }
      
    NextPipeposX = 5;
    
    for(int i = 0; i < 5; i++)
    {
      NewPipe(false);
    }
    
    this.Score = 0;
  }
  
  public Level()
  {
    Reset(true);
  }
  
  void NewPipe(boolean removefirst)
  {
    if(removefirst)
    {
      Pipes.remove(0);
    }
    
    Pipes.add(new PipePair(new PVector(NextPipeposX, random(2.5, 7.5))));
    NextPipeposX += 5.5;
  }
  
  void Update(long time)
  {
    CheckNewPipe();
    CheckScoreIncrease();
    for(Bird bird : Birds)
    {
      bird.Update(time, this);
    }
  }
  
  void CheckNewPipe()
  {
    // if the first pipe is off the screen then remove the first one and add a new one
    if(GetFirstPipeXPosition() - GetFirstBirdXPosition() + birdscreenoffsetx + PipeWidth / 2 <= 0)
    {
      NewPipe(true);
    }
  }
  
  void CheckScoreIncrease()
  {
    if(GetFirstBirdXPosition() >= GetFirstPipeXPosition())
    {
      PipePair firstpipepair = GetFirstPipe();
      
      if(!firstpipepair.GainedScore)
      {
        Score++;
        firstpipepair.GainedScore = true;
      }
    }
  }
  
  void Draw()
  {
    for(PipePair pp : Pipes)
    {
      pp.Draw(UpperPipe, LowerPipe);
    }
    
    for(Bird bird : Birds)
    {
      bird.Draw();
    }
  }
}
