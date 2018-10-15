import tester.Tester;

class CakeRecipe {

  // These are the ingredients to a cake in weight (ounces)
  double eggs;
  double milk;
  double butter;
  double sugar;
  double flour;

  // checks if this is a valid cake recipe
  boolean isValidCakeRecipe() {
    return this.eggs == this.butter &&
        this.eggs + this.milk == this.sugar &&
        this.flour == this.sugar;

  }

  // Creates a Cake Recipe and checks if it is a legal Cake recipe
  CakeRecipe(
      double flour,
      double sugar,
      double eggs,
      double butter,
      double milk,
      boolean areVolumes) {

    if (areVolumes) {
      this.eggs = eggs * 1.75;
      this.milk = milk * 8;
      this.butter = eggs * 1.75;
      this.sugar = flour * 4.25;
      this.flour = flour * 4.25;
    } else {
      this.eggs = eggs;
      this.milk = milk;
      this.butter = butter;
      this.sugar = sugar;
      this.flour = flour;
    }
    String invalidMessage = "Illegal Cake Recipe";
    if (!this.isValidCakeRecipe()) {
      throw new IllegalArgumentException(invalidMessage);
    }
  }

  // Creates a cake recipe with the perfect proportions
  CakeRecipe(double flour,
      double sugar,
      double eggs,
      double butter,
      double milk) {
    this(flour, sugar, eggs, butter, milk, false);
  }

  // generates a cake method based on an ideal cake recipe
  CakeRecipe(double flour, double eggs, double milk) {
    this(flour, flour, eggs, eggs, milk);
  }

  // takes in the flour, eggs and milk as volumes rather than
  // weights and a boolean flag areVolumes
  CakeRecipe(double flour, double eggs, double milk, boolean areVolumes) {
    this(flour, flour, eggs, eggs, milk, areVolumes);
  }

  // checks if this cake is the same as the other cake recipe
  boolean sameRecipe(CakeRecipe other) {
    return (this.eggs - 0.001 <= other.eggs && other.eggs <= this.eggs + 0.001)
        && (this.milk - 0.001 <= other.milk && other.milk <= this.milk + 0.001)
        && (this.butter - 0.001 <= other.butter && other.butter <= this.butter + 0.001)
        && (this.sugar - 0.001 <= other.sugar && other.sugar <= this.sugar + 0.001)
        && (this.flour - 0.001 <= other.flour && other.flour <= this.flour + 0.001);
  }
}

class ExamplesCakeRecipe {
  CakeRecipe C1 = new CakeRecipe(18.0, 18.0, 8.0, 8.0, 10.0);
  CakeRecipe C2 = new CakeRecipe(38.3, 38.3, 7.5, 7.5, 30.8);
  CakeRecipe C3 = new CakeRecipe(25.0, 10.0, 15.0, false);
  CakeRecipe C4 = new CakeRecipe(8.0, 8.0, 2.5, true);
  CakeRecipe C5 = new CakeRecipe(25.0, 10.0, 15.0);

  // tests the constructors
  boolean testConstructor2(Tester t) {
    return t.checkExpect(this.C3.sugar, 25.0)
        && t.checkExpect(this.C5.sugar, 25.0);
  }

  // tests the constructors
  boolean testConstructor1(Tester t) {
    return t.checkConstructorException(
        new IllegalArgumentException("Illegal Cake Recipe"),
        "CakeRecipe", 8.0, 10.0, 8.0, 18.0, 19.0)
        && t.checkConstructorException(
            new IllegalArgumentException("Illegal Cake Recipe"),
            "CakeRecipe", 7.5, 30.8, 7.6, 38.3, 38.3);
  }

  // Test Same recipe
  boolean testSameRecipe(Tester t) {
    return t.checkExpect(C1.sameRecipe(C2), false)
        && t.checkExpect(C1.sameRecipe(new CakeRecipe(18.0, 8.0, 10.0)), true)
        && t.checkExpect(C3.sameRecipe(C4), false);
  }
}
