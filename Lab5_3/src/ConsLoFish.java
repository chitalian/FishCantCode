import java.util.Random;

import javalib.funworld.WorldScene;
import javalib.worldimages.Posn;

// a non-empty list of fish
public class ConsLoFish implements ILoFish {
  IFish first;
  ILoFish rest;

  ConsLoFish(IFish first, ILoFish rest) {
    this.first = first;
    this.rest = rest;
  }

  public ILoFish generateRandomBGFish(Posn bottomRight, Random rand) {
    return new ConsLoFish(this.first, this.rest.generateRandomBGFish(bottomRight, rand));
  }
  
  /*
   * Template
   * -----------
   * fields:
   * ... this.first ... IFish
   * ... this.rest ... ILoFish
   * 
   * Methods of first:
   * ... this.updateVelocity(String keyEvent) ... IFish
   * ... this.addDrag() ... IFish
   * ... this.updatePosnOnTick() ... IFish
   * ... this.drawFish(WorldScene) ... WorldScene
   * ... this.isBigger(int size) ... boolean
   * ... this.eatFish(IFish that) ... IFish
   * ... this.isSame(IFish that) ... boolean
   * ... this.isSamePlayerFish(PlayerFish that) ... boolean
   * ... this.boolean isSameBGFish(BackgroundFish that) ... boolean
   * ... this.combinedWeight(int size) ... int
   * ... this.outsideBounds(double right, double left, double top, double bottom)
   * ... boolean
   * ... this.smallerThan(IFish thatFish) ... boolean
   * ... this.canEat(IFish that) ... boolean
   * 
   * Methods of rest: 
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

  public WorldScene drawLoFish(WorldScene currentScene) {
    return this.rest.drawLoFish(this.first.drawFish(currentScene));
  }

  public ILoFish mapUpdatePosnOnTick() {
    return new ConsLoFish(first.updatePosnOnTick(), rest.mapUpdatePosnOnTick());
  }

  public boolean canBeEaten(IFish thatFish) {
    return thatFish.canEat(this.first) || rest.canBeEaten(thatFish);
  }

  public IFish eatenFish(IFish thatFish) {
    if (thatFish.canEat(this.first)) {
      return this.first;
    } else {
      return this.rest.eatenFish(thatFish);
    }
  }

  public ILoFish remove(IFish that) {
    if (that.isSame(this.first)) {
      return this.rest;
    } else {
      return new ConsLoFish(this.first, this.rest.remove(that));
    }
  }

  public boolean canEat(IFish thatFish) {
    return (this.first.canEat(thatFish) || rest.canEat(thatFish));
  }

  public ILoFish eraseFishOutOfBounds(double right, double left, double top, double bottom) {
    if (this.first.outsideBounds(right, left, top, bottom)) {
      return this.rest.eraseFishOutOfBounds(right, left, top, bottom);
    } else {
      return new ConsLoFish(this.first, this.rest.eraseFishOutOfBounds(right, left, top, bottom));
    }
  }

  public boolean smallerThan(IFish thatFish) {
    return this.first.smallerThan(thatFish) && this.rest.smallerThan(thatFish);
  }

  public int size() {
    return 1 + this.rest.size();
  }
}
