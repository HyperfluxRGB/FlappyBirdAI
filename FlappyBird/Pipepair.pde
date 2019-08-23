class PipePair
{
  PVector Position;
  
  boolean GainedScore;
    
  Rectangle UpperPipe;
  Rectangle LowerPipe;
  
  public PipePair(PVector position)
  {
    this.Position = position;
    GainedScore = false;
    UpperPipe = new Rectangle(new PVector(this.Position.x, this.Position.y + 6.25), PipeWidth, PipeHeight);
    LowerPipe = new Rectangle(new PVector(this.Position.x, this.Position.y - 6.25), PipeWidth, PipeHeight);
  }
  
  void Draw(PImage upperpipe, PImage lowerpipe)
  {
    if(upperpipe != null)
    {
      UpperPipe.Draw(upperpipe);
    }
    else
    {
      UpperPipe.Draw();
    }
      
    if(lowerpipe != null)
    {
      LowerPipe.Draw(lowerpipe);
    }
    else
    {
      LowerPipe.Draw();
    }
  }
}
