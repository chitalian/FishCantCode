import java.util.Random;

import javalib.funworld.WorldScene;
import javalib.worldimages.Posn;

// A List of fish
public interface ILoFish {
  // generates a random Background fish
  ILoFish generateRandomBGFish(Posn bottomRight, Random rand);

  // generates a random Background fish
  ILoFish mapUpdatePosnOnTick();

  // draws all the first in the list of fish on top of one another
  WorldScene drawLoFish(WorldScene currentScene);

  // determines if that fish can eat anything in this list
  boolean canBeEaten(IFish thatFish);

  // deletes all the fish that are out of the given bounds
  ILoFish eraseFishOutOfBounds(double right, double left, double top, double bottom);

  // determines if anything in this list can eat thatFish
  boolean canEat(IFish thatFish);

  // is that fish larger than everything in this list
  boolean smallerThan(IFish thatFish);

  // returns the eaten fish which thatFish has eaten
  // returns thatFish if no fish is found
  IFish eatenFish(IFish thatFish);

  // removes that fish from this list
  ILoFish remove(IFish that);

  // returns the size of the list
  int size();
}
