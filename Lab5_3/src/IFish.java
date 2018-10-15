import javalib.funworld.WorldScene;

public interface IFish {

  IFish updateVelocity(String keyEvent);

  // reduces velocity of IFish based on a drag constant
  IFish addDrag();

  // this fish eating that fish
  IFish eatFish(IFish that);

  // updates the position for each tick
  IFish updatePosnOnTick();

  // Draws a fish onto the worldScene
  WorldScene drawFish(WorldScene currentScene);

  // determines if this fish can eat that
  boolean canEat(IFish that);

  // determines if this fish is bigger than that
  boolean isBigger(int size);

  // lets us know if the Fish is outside of the given bounds
  boolean outsideBounds(double right, double left, double top, double bottom);

  // gets the combined weight of two fish
  int combineWeight(int size);

  // is this fish the same as that fish
  boolean isSame(IFish that);

  // is this fish the same as that fish
  boolean isSamePlayerFish(PlayerFish that);

  // is this fish the same as that fish
  boolean isSameBGFish(BackgroundFish that);

  // checks if this fish is smaller than that fish
  boolean smallerThan(IFish thatFish);
}