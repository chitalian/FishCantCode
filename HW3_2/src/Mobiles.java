import tester.*; // The tester library
import javalib.worldimages.*; // images, like RectangleImage or OverlayImages
import javalib.funworld.*; // the abstract World class and the big-bang library
import javalib.worldcanvas.*; // a canvas to draw onto
import java.awt.Color;

interface IMobile {
  // Computes the total weight of the mobile
  int totalWeight();

  // Computes the total height of the mobile
  int totalHeight();

  // Determines if a mobile is balanced
  boolean isBalanced();

  // Combines this balanced mobile with the given balanced mobile
  // and produces a new mobile
  IMobile buildMobile(IMobile rightside, int stringLength, int strutLength);

  // Computes the current width of this mobile
  int curWidth();

  // Finds the farthest right a Mobile extends
  int farthestRight();

  // Finds the farthest left a Mobile extends
  int farthestLeft();

  // Uses the world image library to draw this mobile
  WorldImage drawMobile();

}

// This is an Abstract class for an IMobile
abstract class AMobile implements IMobile {
  /*
   * Template
   * -----------
   * fields:
   * 
   * Methods:
   * ... this.totalWeight() ... int
   * ... this.totalHeight() ... int
   * ... this.isBalanced() ... int
   * ... this.buildMobile(IMobile rightside, int stringLength, int strutLength)...
   * ... this.drawMobile() ... WorldImage
   * IMobile
   * ... this.curWidth() ... int
   * ... this.farthestLeft() ... int
   * ... this.farthestRight() ... int
   */
  public IMobile buildMobile(IMobile rightside, int stringLength, int strutLength) {
    int combinedWeight = this.totalWeight() + rightside.totalWeight();
    return new Complex(stringLength,
        strutLength * rightside.totalWeight() / combinedWeight,
        strutLength * this.totalWeight() / combinedWeight,
        this,
        rightside);
  }
}

class Simple extends AMobile {
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
   * ... this.buildMobile(IMobile rightside, int stringLength, int strutLength)...
   * IMobile
   * ... this.curWidth() ... int
   * ... this.farthestLeft() ... int
   * ... this.farthestRight() ... int
   * ... this.drawMobile() ... WorldImage
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

  public int curWidth() {
    int factor = 10;
    // Solution by TA Mathias
    return this.weight / factor;
  }

  public int farthestRight() {
    int factor = 10;
    // Solution by TA Mathias
    return (int) Math.round(this.weight / factor / 2.0);
  }

  public int farthestLeft() {
    int factor = 10;
    // Solution by TA Mathias
    return (int) Math.round(this.weight / factor / 2.0);
  }

  public WorldImage drawMobile() {
    return new OverlayOffsetAlign(AlignModeX.PINHOLE, AlignModeY.PINHOLE,
        new LineImage(new Posn(0, this.length), Color.BLACK).movePinhole(0, this.length / 2),
        0, 0,
        new RectangleImage(
            this.curWidth(),
            this.heightOfObject(),
            OutlineMode.SOLID,
            this.color).movePinhole(0, -.5 * this.heightOfObject()))
                .movePinhole(0, -1 * this.length);
  }

}

class Complex extends AMobile {
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
   * 
   * Methods:
   * ... this.totalWeight() ... int
   * ... this.totalHeight() ... int
   * ... this.isBalanced() ... boolean
   * ... this.buildMobile(IMobile rightside, int stringLength, int strutLength)...
   * IMobile
   * ... this.curWidth() ... int
   * ... this.farthestLeft() ... int
   * ... this.farthestRight() ... int
   * ... this.drawMobile() ... WorldImage
   * 
   * Method for fields:
   * 
   * ... this.left.totalWeight() ... int
   * ... this.right.totalWeight() ... int
   * ... this.left.totalHeight() ... int
   * ... this.right.totalHeight() ... int
   * ... this.left.isBalanced() ... int
   * ... this.right.isBalanced() ... int
   * ... this.right.buildMobile(IMobile rightside, int stringLength, int
   * strutLength)... IMobile
   * ... this.right.buildMobile(IMobile rightside, int stringLength, int
   * strutLength)... IMobile
   * ... this.right.curWidth() ... int
   * ... this.left.curWidth() ... int
   * ... this.left.farthestLeft() ... int
   * ... this.right.farthestRight() ... int
   * ... this.left.farthestLeft() ... int
   * ... this.right.farthestRight() ... int
   * ... this.right.drawMobile() ... WorldImage
   * ... this.left.drawMobile() ... WorldImage
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
    return (this.left.totalWeight() * this.leftside == this.right.totalWeight() * this.rightside) &&
        this.left.isBalanced() && this.right.isBalanced();
  }

  public int curWidth() {
    return this.farthestRight() + this.farthestLeft();
  }

  public int farthestRight() {
    if (this.left.farthestRight() - this.leftside < this.right.farthestRight() + this.rightside) {
      return this.right.farthestRight() + this.rightside;
    } else {
      return this.left.farthestRight() - this.leftside;
    }
  }

  public int farthestLeft() {
    if (this.right.farthestLeft() - this.rightside < this.left.farthestLeft() + this.leftside) {
      return this.left.farthestLeft() + this.leftside;
    } else {
      return this.right.farthestLeft() - this.rightside;
    }
  }

  public WorldImage drawMobile() {
    return new OverlayOffsetAlign(AlignModeX.PINHOLE, AlignModeY.PINHOLE,
        new OverlayOffsetAlign(AlignModeX.PINHOLE, AlignModeY.PINHOLE,
            right.drawMobile(),
            0,
            0,
            new OverlayOffsetAlign(AlignModeX.PINHOLE, AlignModeY.PINHOLE,
                left.drawMobile(),
                0,
                0,
                new LineImage(
                    new Posn(this.rightside + this.leftside, 0),
                    Color.BLACK)
                        .movePinhole(-1 * (this.leftside + this.rightside) / 2, 0))
                            .movePinhole(this.leftside + this.rightside, 0))
                                .movePinhole(-1 * this.rightside, 0),
        0,
        0,
        new LineImage(new Posn(0, this.length), Color.BLACK).movePinhole(0, this.length / 2))
            .movePinhole(0, -1 * this.length);
  }

}

class ExamplesMobiles {
  Color blue = new Color(0, 0, 255);
  Color green = new Color(0, 255, 0);
  Color red = new Color(255, 0, 0);
  IMobile exampleSimple = new Simple(2, 20, blue);
  IMobile exampleSimple2 = new Simple(2, 20, blue);
  IMobile exampleSimple3 = new Simple(2, 12, blue);

  IMobile exampleComplex = new Complex(1, 9, 3,
      new Simple(1, 36, this.blue),
      new Complex(2, 8, 1,
          new Simple(1, 12, this.red),
          new Complex(2, 5, 3,
              new Simple(2, 36, this.red),
              new Simple(1, 60, this.green))));
  IMobile exampleComplex_2 = new Complex(10, 90, 30,
      new Simple(10, 360, this.blue),
      new Complex(20, 80, 10,
          new Simple(10, 120, this.red),
          new Complex(20, 50, 30,
              new Simple(20, 360, this.red),
              new Simple(10, 600, this.green))));
  IMobile exampleComplex_3 = new Complex(10, 90, 30,
      new Simple(10, 360, this.blue),
      new Simple(10, 360, this.blue));

  IMobile exampleComplex_4 = new Complex(20, 50, 30,
      new Simple(10, 400, Color.ORANGE),
      new Simple(20, 100, Color.CYAN));

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

  // Test totalWright Function
  boolean testTotalWeight(Tester t) {
    return t.checkExpect(this.example3.totalWeight(), 32) &&
        t.checkExpect(this.exampleSimple.totalWeight(), 20) &&
        t.checkExpect(this.example4.totalWeight(), 971845192) &&
        t.checkExpect(this.exampleComplex.totalWeight(), 144);
  }

  // Test totalHeight Function
  boolean testTotalHeight(Tester t) {
    return t.checkExpect(this.example3.totalHeight(), 7) &&
        t.checkExpect(this.exampleSimple.totalHeight(), 4) &&
        t.checkExpect(this.exampleComplex.totalHeight(), 12);
  }

  // Test isBalanced Function
  boolean testIsBalanced(Tester t) {
    return t.checkExpect(this.example3.isBalanced(), true) &&
        t.checkExpect(this.exampleSimple.isBalanced(), true) &&
        t.checkExpect(this.exampleComplex.isBalanced(), true) &&
        t.checkExpect(this.example4.isBalanced(), false);
  }

  // Test buildMobiles
  boolean testBuildMobiles(Tester t) {
    return t.checkExpect(
        this.exampleSimple.buildMobile(this.exampleSimple, 6, 10),
        new Complex(6, 5, 5, this.exampleSimple, this.exampleSimple2)) &&
        t.checkExpect(
            this.exampleSimple3.buildMobile(
                this.exampleComplex, 98, 26),
            new Complex(98, 24, 2, this.exampleSimple3, this.exampleComplex))
        &&
        t.checkExpect(
            this.example3.buildMobile(
                this.exampleComplex, 2, 33),
            new Complex(2, 27, 6, this.example3, this.exampleComplex));

  }

  // Computes the current width of a mobile test
  boolean testCurWidth(Tester t) {
    return t.checkExpect(this.exampleSimple.curWidth(), 2) &&
        t.checkExpect(this.exampleComplex.curWidth(), 21) &&
        t.checkExpect(
            (new Complex(1, 9, 3,
                new Simple(1, 36, this.blue),
                new Complex(2, 8, 1,
                    new Simple(1, 12, this.red),
                    new Complex(2, 20, 1,
                        new Simple(2, 3, this.red),
                        new Simple(1, 60, this.green))))).curWidth(),
            24);
  }

  // Tests our helperfunction farthestRight()
  boolean testFarthestRight(Tester t) {
    return t.checkExpect(this.exampleSimple.farthestRight(), 1) &&
        t.checkExpect(this.exampleComplex.farthestRight(), 10);
  }

  // Tests our helperfunction farthestLeft()
  boolean testFarthestLeft(Tester t) {
    return t.checkExpect(this.exampleSimple.farthestLeft(), 1) &&
        t.checkExpect(this.exampleComplex.farthestLeft(), 11) &&
        t.checkExpect(
            (new Complex(1, 9, 3,
                new Simple(1, 36, this.blue),
                new Complex(2, 8, 1,
                    new Simple(1, 12, this.red),
                    new Complex(2, 20, 1,
                        new Simple(2, 100, this.red),
                        new Simple(1, 60, this.green))))).farthestLeft(),
            21);

  }

  // tests the drawModile() function
  boolean testDrawMobile(Tester t) {
    return t.checkExpect(this.exampleSimple.drawMobile(),
        new OverlayOffsetAlign(AlignModeX.PINHOLE, AlignModeY.PINHOLE,
            new LineImage(new Posn(0, 2), Color.BLACK).movePinhole(0, 2 / 2),
            0, 0,
            new RectangleImage(
                this.exampleSimple.curWidth(),
                2,
                OutlineMode.SOLID,
                this.blue).movePinhole(0, -.5 * 2))
                    .movePinhole(0, -1 * 2));
  }

  // used to draw the actual image on a canvas
  boolean testDrawRenderMobile(Tester t) {
    int x = 600, y = 600;
    WorldCanvas c = new WorldCanvas(x, y);
    WorldScene s = new WorldScene(x, y);

    return c.drawScene(s.placeImageXY(
        new ScaleImageXY(
            this.exampleComplex_2.buildMobile(
                exampleComplex_2.buildMobile(exampleComplex_4, 150, 180), 10, 150).drawMobile(), 1, 1),
        x/2, y/2))
        && c.show();
  }

}