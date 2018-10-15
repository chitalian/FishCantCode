import java.util.Random;

import javalib.funworld.WorldScene;
import javalib.worldimages.Posn;

// empty list of fish
public class MtLoFish implements ILoFish {
  MtLoFish() {

  }

  /*
  * Methods:
  * ... this.drawLoFish(WorldScene currentScene) ... WorldScene
  * ... this.mapUpdatePosnOnTick() ... ILoFish
  * ... this.canBeEaten(IFish thatFish) ... boolean
  * ... this.eatenFish(IFish thatFish) ... IFish
  * ... this.remove(remove(IFish that)) ... ILoFish
  * ... this.canEat(IFish thatFish) ... boolean
  * ... this.eraseFishOutOfBounds(double right, double left, double top, double bottom) ... ILoFish
  * ... this.smallerThan(IFish thatFish) ... boolean 
  * ... this.size() ... int
  * 
  */
  public ILoFish generateRandomBGFish(Posn bottomRight, Random rand) {
    // random size 1 - 5
    int randomSize = rand.nextInt(5) + 1;// (int) (Math.random() * 5) + 1;

    boolean rightSide = (rand.nextInt(2) == 1);
    int randomY = rand.nextInt(bottomRight.y);
    if (rightSide) {
      return new ConsLoFish(
          new BackgroundFish(new Posn(bottomRight.x, randomY), new Velocity(-1, 0), randomSize),
          this);
    } else {
      return new ConsLoFish(
          new BackgroundFish(new Posn(0, randomY), new Velocity(1, 0), randomSize),
          this);
    }

  }

  public WorldScene drawLoFish(WorldScene currentScene) {
    return currentScene;
  }

  public ILoFish mapUpdatePosnOnTick() {
    return this;
  }

  public boolean canBeEaten(IFish thatFish) {
    return false;
  }

  public IFish eatenFish(IFish thatFish) {
    return thatFish;
  }

  public ILoFish remove(IFish that) {
    return this;
  }

  public boolean canEat(IFish thatFish) {
    return false;
  }

  public ILoFish eraseFishOutOfBounds(double right, double left, double top, double bottom) {
    return this;
  }

  public boolean smallerThan(IFish thatFish) {
    return true;
  }

  public int size() {
    return 0;
  }
}
