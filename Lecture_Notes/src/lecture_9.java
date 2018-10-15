interface IShape {
  boolean isCircle();
  boolean isRectangle();
  boolean isSquare();
}

abstract class AShape implements IShape {
  String color;
  int points;

  AShape(String color, int points) {

  }

  public boolean isCircle() {
    return false;
  }

  public boolean isRectangle() {
    return false;
  }

  public boolean isSquare() {
    return false;
  }

}

class Circle extends AShape {
  int radius;

  Circle(String color, int points, int radius) {
    super(color, points);
    this.radius = radius;
  }
  
  public boolean isCircle() {
    return true;
  }

}

class Rectangle extends AShape {
  int height;
  int width;

  Rectangle(String color, int points, int height, int width) {
    super(color, points);
    this.height = height;
    this.width = width;
  }
  public boolean isRectangle() {
    return true;
  }
}

class Square extends Rectangle {

  Square(String color, int points, int side) {
    super(color, points, side, side);
  }
  
  public boolean isRectangle() {
    return false;
  }
  public boolean isSquare() {
    return true;
  }
}

////////////////////////////////////////////////////////////////////////////

abstract class AStudent {
  String name;
  int creditsPassed;

  AStudent(String name, int creditsPassed) {
    this.name = name;
    this.creditsPassed = creditsPassed;
  }
}

class Undergraduate extends AStudent {

  int graduationYear;

  Undergraduate(String name, int creditsPassed, int graduationYear) {
    super(name, creditsPassed);
    this.graduationYear = graduationYear;
  }

  public AStudent addCredits(int creditsToAdd) {
    return new Undergraduate(this.name, this.creditsPassed + creditsToAdd, this.graduationYear);
  }
}

class GradStudent extends AStudent {
  int enteringYear;
  String dept;

  GradStudent(String name, int creditsPassed, int enteringYear, String dept) {
    super(name, creditsPassed);
    this.enteringYear = enteringYear;
    this.dept = dept;
  }

  public AStudent addCredits(int creditsToAdd) {
    return new GradStudent(this.name, this.creditsPassed + creditsToAdd, this.enteringYear, this.dept);
  }
}

class ContinuingEducationStudent extends AStudent {

  String dept;

  ContinuingEducationStudent(String name, int creditsPassed, String dept) {
    super(name, creditsPassed);
    this.dept = dept;
  }

  public AStudent addCredits(int creditsToAdd) {
    return new ContinuingEducationStudent(this.name, this.creditsPassed + creditsToAdd, this.dept);
  }

}
