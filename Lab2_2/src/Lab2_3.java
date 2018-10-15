interface GamePiece {
  boolean isBaseTile();
}

class BaseTile implements GamePiece{
  int value;
  
  BaseTile(int value){
    this.value = value;
  }
  public boolean isBaseTile() {
    return true;
  }
  
  
  
}

class MergeTile implements GamePiece{
  GamePiece piece1;
  GamePiece piece2;
  
  MergeTile(GamePiece piece1, GamePiece piece2){
    this.piece1 = piece1;
    this.piece2 = piece2;
  }
  public boolean isBaseTile() {
    return false;
  }
  
  int countBaseTiles() {
    
    if(piece1.isBaseTile())
    {
      
    }
    return 
  }
}