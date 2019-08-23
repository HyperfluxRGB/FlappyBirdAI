class Rectangle
{
  PVector Position;
  
  float Width;
  
  float Height;
  
  public Rectangle(PVector position, float _width, float _height)
  {
    if(_width <= 0)
    {
      throw new IllegalArgumentException("Width has to be greater or equal to 0.");
    }
    
    if(_height <= 0)
    {
      throw new IllegalArgumentException("Height has to be greater or equal to 0.");
    }
    
    this.Width = _width;
    this.Height = _height;
    
    if(position == null)
    {
      this.Position = position;
    }
    else
    {
      this.Position = position;
    }
  }
  
  PVector GetClosestPointInRect(PVector position)
  {
    if(position == null)
    {
      throw new IllegalArgumentException("Position cannot be null.");
    }
    
    float closestpointinrectx = clamp(position.x, this.Position.x - this.Width / 2, this.Position.x + this.Width / 2);
    float closestpointinrecty = clamp(position.y, this.Position.y - this.Height / 2, this.Position.y + this.Height / 2);
    
    return new PVector(closestpointinrectx, closestpointinrecty);
  }
  
  boolean CheckCircleCollision(PVector position, float radius)
  {
    if(position == null)
    {
      throw new IllegalArgumentException("Position cannot be null.");
    }
    
    if(radius <= 0)
    {
      throw new IllegalArgumentException("Radius has to be greater than or equal to 0.");
    }
    
    PVector closestpointinrect = GetClosestPointInRect(position);
    
    PVector vectortocircle = PVector.sub(closestpointinrect, position);
    
    return vectortocircle.mag() <= radius;
  }
  
  void Draw()
  {
    fill(255);
    rectMode(CENTER);
    rect(this.Position.x, -this.Position.y, this.Width, this.Height);
  }
  
  void Draw(PImage imagetofit)
  {    
    imageMode(CENTER);
    image(imagetofit, this.Position.x, -this.Position.y, this.Width, this.Height);
  }
}
