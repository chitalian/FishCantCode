import tester.*; // The tester library
import javalib.worldimages.*; // images, like RectangleImage or OverlayImages
import javalib.funworld.*; // the abstract World class and the big-bang library
import java.awt.Color; // general colors (as triples of red,green,blue values)
                       // and predefined colors (Red, Green, Yellow, Blue, Black, White)

interface IMobile {
  // Computes the total weight of the mobile
  int totalWeight();

  // Computes the total height of the mobile
  int totalHeight();

  // Determines if a mobile is balanced
  boolean isBalanced();
  
  IMobile buildMobile(IMobile rightside, int stringLength, int strutLength);
}

class Simple implements IMobile {
  int length;
  int weight;
  Color color;

  Simple(int length, int weight, Color color) {
    this.length = length;
    this.weight = weight;
    this.color = color;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.length ... int
   * ... this.weight ... int
   * ... this.color ... Color
   * 
   * Methods:
   * ... this.totalWeight() ... int
   * ... this.totalHeight() ... int
   * ... this.isBalanced() ... int
   */
  public int totalWeight() {
    return this.weight;
  }

  // Helper Function
  // Gets the Height of the object
  private int heightOfObject() {
    int factor = 10;
    return this.weight / factor;
  }

  public int totalHeight() {
    return this.length + this.heightOfObject();
  }

  public boolean isBalanced() {
    return true;
  }

}

class Complex implements IMobile {
  int length;
  int leftside;
  int rightside;
  IMobile left;
  IMobile right;

  Complex(int length, int leftside, int rightside, IMobile left, IMobile right) {
    this.length = length;
    this.leftside = leftside;
    this.rightside = rightside;
    this.left = left;
    this.right = right;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.length ... int
   * ... this.leftside ... int
   * ... this.rightside ... int
   * ... this.color ... Color
   * ... this.left ... IMobile
   * ... this.right ... IMobile
   * 
   * Methods:
   * ... this.totalWeight() ... int
   * ... this.totalHeight() ... int
   * ... this.isBalanced() ... boolean
   * 
   * Method for fields:
   * 
   * ... this.left.totalWeight() ... int
   * ... this.right.totalWeight() ... int
   * ... this.left.totalHeight() ... int
   * ... this.right.totalHeight() ... int
   * ... this.left.isBalanced() ... int
   * ... this.right.isBalanced() ... int
   */
  public int totalWeight() {
    return this.left.totalWeight() + this.right.totalWeight();
  }

  public int totalHeight() {
    if (this.left.totalHeight() > this.right.totalHeight()) {
      return this.length + this.left.totalHeight();
    } else {
      return this.length + this.right.totalHeight();
    }
  }

  public boolean isBalanced() {
    return (this.left.totalWeight() * this.leftside == 
        this.right.totalWeight() * this.rightside) &&
        this.left.isBalanced() && this.right.isBalanced();
  }

}

class ExamplesMobiles {
  Color blue = new Color(0, 0, 255);
  Color green = new Color(0, 255, 0);
  Color red = new Color(255, 0, 0);
  IMobile exampleSimple = new Simple(2, 20, blue);

  IMobile exampleComplex = new Complex(1, 9, 3,
      new Simple(1, 36, this.blue),
      new Complex(2, 8, 1,
          new Simple(1, 12, this.red),
          new Complex(2, 5, 3,
              new Simple(2, 36, this.red),
              new Simple(1, 60, this.green))));

  IMobile example3 = new Complex(1, 1, 1,
      new Simple(5, 16, this.blue),
      new Complex(1, 1, 1,
          new Simple(4, 8, this.red),
          new Complex(1, 1, 1,
              new Simple(3, 4, this.green),
              new Complex(1, 1, 1,
                  new Simple(2, 2, this.blue),
                  new Complex(1, 1, 1,
                      new Simple(1, 1, this.red),
                      new Simple(1, 1, this.red))))));
  
  IMobile example4 = new Complex(1, 1, 1,
      new Simple(5, 971824897, this.blue),
      new Complex(1, 1, 1,
          new Simple(4, 8, this.red),
          new Complex(1, 1, 1,
              new Simple(3, 4, this.green),
              new Complex(1, 1, 1,
                  new Simple(2, 19048, this.blue),
                  new Complex(1, 198347031, 1,
                      new Simple(1, 1234, this.red),
                      new Simple(1, 1, this.red))))));

  boolean testTotalWeight(Tester t) {
    return t.checkExpect(example3.totalWeight(), 32) &&
        t.checkExpect(exampleSimple.totalWeight(), 20) &&
        t.checkExpect(exampleComplex.totalWeight(), 144);
  }

  boolean testTotalHeight(Tester t) {
    return t.checkExpect(example3.totalHeight(), 7) &&
        t.checkExpect(exampleSimple.totalHeight(), 4) &&
        t.checkExpect(exampleComplex.totalHeight(), 12);
  }

  boolean testIsBalanced(Tester t) {
    return t.checkExpect(example3.isBalanced(), true) &&
        t.checkExpect(exampleSimple.isBalanced(), true) &&
        t.checkExpect(exampleComplex.isBalanced(), true) &&
        t.checkExpect(example4.isBalanced(), false);
  }
}