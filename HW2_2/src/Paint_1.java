import tester.*;
import java.awt.Color;

interface IPaint {
  // Generates a Color object based on this IPaint
  Color getFinalColor();

  // Counts the number of paints in this IPaint
  // *Note: includes darken and brighten as a paint
  int countPaints();

  // Computes the number of times this paint was mixed in some way
  int countMixes();

  // Computes how deeply mixtures are nested in the formula
  int formulaDepth();

  // Produces a String representing the contents of this paint,
  String mixingFormula(int depth);
}

class Solid implements IPaint {
  String name;
  Color color;

  Solid(String name, Color color) {
    this.name = name;
    this.color = color;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.name ... String
   * ... this.color ... Color
   * Methods:
   * ... this.getFinalColor() ... Color
   * ... this.countPaints() ... int
   * ... this.countMixes() ... int
   * ... this.formulaDepth() ... int
   * ... this.mixingFormula(int depth) ... String
   * Methods For Fields:
   */

  public Color getFinalColor() {
    return this.color;
  }

  public int countPaints() {
    return 1;
  }

  public int countMixes() {
    return 0;
  }

  public int formulaDepth() {
    return 0;
  }

  public String mixingFormula(int depth) {
    return this.name;
  }
}

class Combo implements IPaint {
  String name;
  IMixture operation;

  Combo(String name, IMixture operation) {
    this.name = name;
    this.operation = operation;
  }

  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.name ... String
   * ... this.operation ... IMixture
   * Methods:
   * ... this.getFinalColor() ... Color
   * ... this.countPaints() ... int
   * ... this.countMixes() ... int
   * ... this.formulaDepth() ... int
   * ... this.mixingFormula(int depth) ... String
   * Methods For Fields:
   * ... this.operation.countPaints() ... int
   * ... this.operation.countMixes() ... int
   * ... this.opertation.formulaDepth() ... int
   * ... this.operation.mixingFormula(int depth) ... String
   */
  public Color getFinalColor() {
    return this.operation.getFinalColor();
  }

  public int countPaints() {
    return this.operation.countPaints();
  }

  public int countMixes() {
    return this.operation.countMixes();
  }

  public int formulaDepth() {
    return this.operation.formulaDepth();
  }

  public String mixingFormula(int depth) {
    if (depth > this.formulaDepth()) {
      return this.mixingFormula(this.formulaDepth());
    } else {
      if (depth <= 0) {
        return this.name;
      } else {
        return this.operation.mixingFormula(depth - 1);
      }
    }
  }
}

interface IMixture {
  // Generates a Color object based on this IPaint
  Color getFinalColor();

  // Counts the number of paints in this IPaint
  // *Note: includes darken and brighten as a paint
  int countPaints();

  // Computes the number of times this paint was mixed in some way
  int countMixes();

  // Computes how deeply mixtures are nested in the formula
  int formulaDepth();

  // Produces a String representing the contents of this paint,
  String mixingFormula(int depth);
}

class Darken implements IMixture {
  IPaint color;

  Darken(IPaint color) {
    this.color = color;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.color ... Color
   * Methods:
   * ... this.getFinalColor() ... Color
   * ... this.countPaints() ... int
   * ... this.countMixes() ... int
   * ... this.formulaDepth() ... int
   * ... this.mixingFormula(int depth) ... String
   * 
   * Methods For Fields:
   * ... this.color.getFinal.Color() ... Color
   * ... this.color.countPaints() ... int
   * ... this.color.countMixes() ... int
   * ... this.color.formulaDepth() ... int
   * ... this.color.mixingFormula(int depth) ... String
   */

  public Color getFinalColor() {
    return this.color.getFinalColor().darker();
  }

  public int countPaints() {
    return 1 + this.color.countPaints();
  }

  public int countMixes() {
    return 1 + this.color.countMixes();
  }

  public int formulaDepth() {
    return 1 + this.color.formulaDepth();
  }

  public String mixingFormula(int depth) {
    return "darken(" + color.mixingFormula(depth) + ")";
  }
}

class Brighten implements IMixture {
  IPaint color;

  Brighten(IPaint color) {
    this.color = color;
  }

  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.color ... Color
   * Methods:
   * ... this.getFinalColor() ... Color
   * ... this.countPaints() ... int
   * ... this.countMixes() ... int
   * ... this.formulaDepth() ... int
   * ... this.mixingFormula(int depth) ... String
   * 
   * Methods For Fields:
   * ... this.color.getFinal.Color() ... Color
   * ... this.color.countPaints() ... int
   * ... this.color.countMixes() ... int
   * ... this.color.formulaDepth() ... int
   * ... this.color.mixingFormula(int depth) ... String
   */
  public Color getFinalColor() {
    return this.color.getFinalColor().brighter();
  }

  public int countPaints() {
    return 1 + this.color.countPaints();
  }

  public int countMixes() {
    return 1 + this.color.countMixes();
  }

  public int formulaDepth() {
    return 1 + this.color.formulaDepth();
  }

  public String mixingFormula(int depth) {
    return "brighten(" + color.mixingFormula(depth) + ")";
  }
}

class Blend implements IMixture {
  IPaint c1;
  IPaint c2;

  Blend(IPaint c1, IPaint c2) {
    this.c1 = c1;
    this.c2 = c2;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.c1 ... Color
   * ... this.c2 ... Color
   * Methods:
   * ... this.getFinalColor() ... Color
   * ... this.countPaints() ... int
   * ... this.countMixes() ... int
   * ... this.formulaDepth() ... int
   * ... this.mixingFormula(int depth) ... String
   * Methods For Fields:
   * ... this.c1.getFinal.Color() ... Color
   * ... this.c2.getFinal.Color() ... Color
   * ... this.c1.countPaints() ... int
   * ... this.c2.countPaints() ... int
   * ... this.c1.countMixes() ... int
   * ... this.c2.countMixes() ... int
   * ... this.c1.formulaDepth() ... int
   * ... this.c2.formulaDepth() ... int
   * ... this.c1.mixingFormula(int depth) ... String
   * ... this.c2.mixingFormula(int depth) ... String
   */

  public Color getFinalColor() {
    return new Color(
        (this.c1.getFinalColor().getRed() + this.c2.getFinalColor().getRed()) / 2,
        (this.c1.getFinalColor().getGreen() + this.c2.getFinalColor().getGreen()) / 2,
        (this.c1.getFinalColor().getBlue() + this.c2.getFinalColor().getBlue()) / 2);
  }

  public int countPaints() {
    return this.c1.countPaints() + this.c2.countPaints();
  }

  public int countMixes() {
    return 1 + this.c1.countMixes() + this.c2.countMixes();
  }

  public int formulaDepth() {
    if (this.c1.formulaDepth() > this.c2.formulaDepth()) {
      return 1 + this.c1.formulaDepth();
    } else {
      return 1 + this.c2.formulaDepth();
    }
  }

  public String mixingFormula(int depth) {
    return "blend(" + this.c1.mixingFormula(depth) +
        ", " +
        this.c2.mixingFormula(depth) +
        ")";
  }
}

class ExamplesPaint {
  IPaint red = new Solid("red", new Color(255, 0, 0));
  IPaint green = new Solid("green", new Color(0, 255, 0));
  IPaint blue = new Solid("blue", new Color(0, 0, 255));
  IPaint purple = new Combo("purple", new Blend(this.red, this.blue));
  IPaint darkPurple = new Combo("dark purple", new Darken(this.purple));
  IPaint darkDarkPurple = new Combo("dark purple", new Blend(this.darkPurple, this.darkPurple));
  IPaint khaki = new Combo("khaki", new Blend(this.red, this.green));
  IPaint yellow = new Combo("yellow", new Brighten(this.khaki));
  IPaint mauve = new Combo("mauve", new Blend(this.purple, this.khaki));
  IPaint pink = new Combo("pink", new Brighten(this.mauve));
  IPaint coral = new Combo("coral", new Blend(this.pink, this.khaki));

  IPaint random1 = new Combo("interesting color 1", new Blend(this.coral, this.mauve));
  IPaint random2 = new Combo("interesting color 2", new Brighten(this.coral));

  boolean testGetFinalColor(Tester t) {
    return t.checkExpect(this.red.getFinalColor(), new Color(255, 0, 0)) &&
        t.checkExpect(this.khaki.getFinalColor(), new Color(255 / 2, 255 / 2, 0)) &&
        t.checkExpect(this.purple.getFinalColor(), new Color(255 / 2, 0, 255 / 2)) &&
        t.checkExpect(this.mauve.getFinalColor(), new Color((255 / 2), (255 / 2 / 2), (255 / 2) / 2));

  }

  boolean testCountPaints(Tester t) {
    return t.checkExpect(this.red.countPaints(), 1) &&
        t.checkExpect(this.purple.countPaints(), 2) &&
        t.checkExpect(this.darkPurple.countPaints(), 3) &&
        t.checkExpect(this.khaki.countPaints(), 2) &&
        t.checkExpect(this.mauve.countPaints(), 4) &&
        t.checkExpect(this.pink.countPaints(), 5);

  }

  boolean testCountMixes(Tester t) {
    return t.checkExpect(this.red.countMixes(), 0) &&
        t.checkExpect(this.purple.countMixes(), 1) &&
        t.checkExpect(this.darkPurple.countMixes(), 2) &&
        t.checkExpect(this.darkDarkPurple.countMixes(), 5) &&
        t.checkExpect(this.khaki.countMixes(), 1) &&
        t.checkExpect(this.mauve.countMixes(), 3) &&
        t.checkExpect(this.pink.countMixes(), 4);

  }

  boolean testFormulaDepth(Tester t) {
    return t.checkExpect(this.red.formulaDepth(), 0) &&
        t.checkExpect(this.purple.formulaDepth(), 1) &&
        t.checkExpect(this.darkPurple.formulaDepth(), 2) &&
        t.checkExpect(this.darkDarkPurple.formulaDepth(), 3) &&
        t.checkExpect(this.khaki.formulaDepth(), 1) &&
        t.checkExpect(this.mauve.formulaDepth(), 2) &&
        t.checkExpect(this.pink.formulaDepth(), 3);

  }

  boolean testmixingFormula(Tester t) {
    return t.checkExpect(this.red.mixingFormula(0), "red") &&
        t.checkExpect(this.red.mixingFormula(1000), "red") &&
        t.checkExpect(this.pink.mixingFormula(2),
            "brighten(blend(purple, khaki))")
        &&
        t.checkExpect(this.pink.mixingFormula(3),
            "brighten(blend(blend(red, blue), blend(red, green)))")
        &&
        t.checkExpect(this.pink.mixingFormula(1000),
            "brighten(blend(blend(red, blue), blend(red, green)))")
        &&
        t.checkExpect(this.pink.mixingFormula(0), "pink") &&
        t.checkExpect(this.pink.mixingFormula(1), "brighten(mauve)");

  }

}
