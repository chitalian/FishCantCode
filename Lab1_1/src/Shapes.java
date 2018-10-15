import tester.*;
import javalib.worldimages.*; // images, like RectangleImage or OverlayImages
import javalib.funworld.*; // the abstract World class and the big-bang library
import java.awt.Color;
import java.util.ArrayList; // general colors (as triples of red,green,blue values)
// and predefined colors (Red, Green, Yellow, Blue, Black, White)

class Tile {
  // The number on the tile. Use 0 to represent the hole
  int value;

  // Draws this tile onto the background at the specified logical coordinates
  WorldImage drawAt(int col, int row, WorldImage background) {
    return new EllipseImage(300, 600, OutlineMode.SOLID, Color.BLUE);
  }
}

class FifteenGame extends World {
  // represents the rows of tiles
  ArrayList<ArrayList<Tile>> tiles;

  // draws the game
  public WorldScene makeScene() {
    return new WorldScene(10, 10);
  }
}

//Example of IceCream
class ExamplesMyWorldProgram {
  boolean testBigBang(Tester t) {
    FifteenGame w = new FifteenGame();
    int worldWidth = 1000;
    int worldHeight = 100;
    double tickRate = 10;
    return w.bigBang(worldWidth, worldHeight, tickRate);
  }

}

class Address {
  String street;
  String city;
  String state;

  Address(String street, String city, String state) {
    this.street = street;
    this.city = city;
    this.state = state;
  }

  // is this address in the given state?
  boolean inState(String st) {
    return this.state.equals(st);
  }
}

interface ILoAddress {
  // get the list of addresses that are in the given state
  ILoAddress addressesInState(String st);
}

class MtLoAddress implements ILoAddress {
  // get the list of Addresses in this empty list that are in the given state
  public ILoAddress addressesInState(String st) {
    return this;
  }
}

class ConsLoAddress implements ILoAddress {
  Address first;
  ILoAddress rest;

  ConsLoAddress(Address first, ILoAddress rest) {
    this.first = first;
    this.rest = rest;
  }

  public ILoAddress addressesInState(String st) {
    if (this.first.inState(st)) {
      return new ConsLoAddress(this.first, this.rest.addressesInState(st));
    } else {
      return this.rest.addressesInState(st);
    }
  }

  // your answer would go here
}
