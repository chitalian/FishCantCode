import tester.*;

interface IEntertainment {
  // compute the total price of this Entertainment
  double totalPrice();

  // computes the minutes of entertainment of this IEntertainment
  int duration();

  // produce a String that shows the name and price of this IEntertainment
  String format();

  // is this IEntertainment the same as that one?
  boolean sameEntertainment(IEntertainment that);

  // is this magazine the same as that magazine
  boolean sameMagazine(Magazine that);

  // is this TVSeries the same as that magazine
  boolean sameTVSeries(TVSeries that);

  // is this Podcast the same as that magazine
  boolean samePodcast(Podcast that);

}

abstract class AEntertainment implements IEntertainment {
  String name;
  double price; // represents price per issue
  int installments; // number of issues per year

  AEntertainment(String name, double price, int installments) {
    this.name = name;
    this.price = price;
    this.installments = installments;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.name ... String
   * ... this.price ... double
   * ... this.installments ... int
   * 
   * Methods:
   * ... this.totalPrice() ... int
   * ... this.duration() ... int
   * ... this.format() ... String
   * ... this.sameMagazine(Magazine that) ... boolean
   * ... this.sameTVSeries(TVSeries that) ... boolean
   * ... this.samePodcast(Podcast that) ... boolean
   * 
   */

  // computes the price of a yearly subscription
  public double totalPrice() {
    return this.price * this.installments;
  }

  // computes the minutes of entertainment
  public int duration() {
    return 50 * this.installments;
  }

  public String format() {
    return this.name.concat(", ".concat(String.valueOf(this.price))).concat(".");
  }

  // is this magazine the same as that magazine
  public boolean sameMagazine(Magazine that) {
    return false;
  }

  // is this TVSeries the same as that magazine
  public boolean sameTVSeries(TVSeries that) {
    return false;
  }

  // is this Podcast the same as that magazine
  public boolean samePodcast(Podcast that) {
    return false;
  }
}

class Magazine extends AEntertainment {

  String genre;
  int pages;

  Magazine(String name, double price, String genre, int pages, int installments) {
    super(name, price, installments);
    this.genre = genre;
    this.pages = pages;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.name ... String
   * ... this.price ... double
   * ... this.installments ... int
   * ... this.genre ... String
   * ... this.pages ... int
   * 
   * Methods:
   * ... this.totalPrice() ... int
   * ... this.duration() ... int
   * ... this.format() ... String
   * ... this.sameMagazine(Magazine that) ... boolean
   * ... this.sameEntertainment(IEntertainment that) ... boolean
   */

  // is this magazine the same as that magazine
  public boolean sameMagazine(Magazine that) {
    return this.name == that.name
        && this.pages == that.pages
        && this.genre == that.genre
        && this.price == that.price
        && this.installments == that.installments;
  }

  // is this Magazine the same as that IEntertainment?
  public boolean sameEntertainment(IEntertainment that) {
    return that.sameMagazine(this);
  }

  // computes the minutes of entertainment of this Magazine, (includes all
  // installments)
  @Override
  public int duration() {
    return 5 * this.pages * this.installments;
  }
}

class TVSeries extends AEntertainment {
  String corporation;

  TVSeries(String name, double price, int installments, String corporation) {
    super(name, price, installments);
    this.corporation = corporation;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.name ... String
   * ... this.price ... double
   * ... this.installments ... int
   * ... this.corporation ... String
   * 
   * Methods:
   * ... this.totalPrice() ... int
   * ... this.duration() ... int
   * ... this.format() ... String
   * ... this.sameTVSeries(TVSeries that) ... boolean
   * ... this.sameEntertainment(IEntertainment that) ... boolean
   */

  // is this TVSeries the same as that magazine
  public boolean sameTVSeries(TVSeries that) {
    return this.name == that.name
        && this.corporation == that.corporation
        && this.price == that.price
        && this.installments == that.installments;
  }

  // is this TVSeries the same as that IEntertainment?
  public boolean sameEntertainment(IEntertainment that) {
    return that.sameTVSeries(this);
  }

}

class Podcast extends AEntertainment {

  Podcast(String name, double price, int installments) {
    super(name, price, installments);
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.name ... String
   * ... this.price ... double
   * ... this.installments ... int
   * 
   * Methods:
   * ... this.totalPrice() ... int
   * ... this.duration() ... int
   * ... this.format() ... String
   * ... this.samePodcast(Podcast that) ... boolean
   * ... this.sameEntertainment(IEntertainment that) ... boolean
   */

  // is this Podcast the same as that magazine
  public boolean samePodcast(Podcast that) {
    return this.name == that.name
        && this.price == that.price
        && this.installments == that.installments;
  }

  // is this Podcast the same as that IEntertainment?
  public boolean sameEntertainment(IEntertainment that) {
    return that.samePodcast(this);
  }
}

class ExamplesEntertainment {
  IEntertainment rollingStone = new Magazine("Rolling Stone", 2.55, "Music", 60, 12);
  IEntertainment houseOfCards = new TVSeries("House of Cards", 5.25, 13, "Netflix");
  IEntertainment serial = new Podcast("Serial", 0.0, 8);

  IEntertainment pen = new Magazine("Pen", 6, "Trvel", 150, 458);
  IEntertainment theFlash = new TVSeries("The Flash", 0.0, 148, "CWTV");
  IEntertainment commandLineHeros = new Podcast("Red Hat Command Line Heros", 0.0, 9);

  // testing total price method
  boolean testTotalPrice(Tester t) {
    return t.checkInexact(this.rollingStone.totalPrice(), 2.55 * 12, .0001)
        && t.checkInexact(this.houseOfCards.totalPrice(), 5.25 * 13, .0001)
        && t.checkInexact(this.serial.totalPrice(), 0.0, .0001)
        && t.checkInexact(this.pen.totalPrice(), 458.0 * 6, .0001)
        && t.checkInexact(this.theFlash.totalPrice(), 0.0, .0001)
        && t.checkInexact(this.commandLineHeros.totalPrice(), 0.0, .0001);
  }

  // testing duration function of an entertainment
  boolean testDuration(Tester t) {
    return t.checkExpect(this.rollingStone.duration(), 60 * 5 * 12)
        && t.checkExpect(this.houseOfCards.duration(), 50 * 13)
        && t.checkExpect(this.serial.duration(), 50 * 8)
        && t.checkExpect(this.pen.duration(), 343500)
        && t.checkExpect(this.theFlash.duration(), 50 * 148)
        && t.checkExpect(this.commandLineHeros.duration(), 50 * 9);
  }

  // testing duration function of an entertainment
  boolean testFormat(Tester t) {
    return t.checkExpect(this.rollingStone.format(), "Rolling Stone, 2.55.")
        && t.checkExpect(this.houseOfCards.format(), "House of Cards, 5.25.")
        && t.checkExpect(this.serial.format(), "Serial, 0.0.");
  }

  // testing duration function of an entertainment
  boolean testSameEntertainment(Tester t) {
    return t.checkExpect(this.rollingStone.sameEntertainment(this.rollingStone), true)
        && t.checkExpect(this.houseOfCards.sameEntertainment(this.rollingStone), false)
        && t.checkExpect(this.serial.sameEntertainment(this.commandLineHeros), false);
  }
}