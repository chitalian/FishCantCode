

interface IShape {
  
}


class Circle implements IShape{
  int radius;
  
  
  boolean sameCircle(Circle that) {
    return that.radius == this.radius;
  }
  //Dont use instanceof
  boolean sameShape(IShape that) {
    if(that instanceof Circle) {
      return this.sameCircle((Circle)that);
    }else {
      return false;
    }
  }
  
  // instead create three methods "IsCircle"
}

class Rectangle implements IShape{
  
}


class ExampleShapes{
  
}