import java.awt.Color;
import javalib.funworld.WorldScene;
import javalib.worldimages.CircleImage;
import javalib.worldimages.OutlineMode;
import javalib.worldimages.Posn;

public class BackgroundFish extends AFish {

  BackgroundFish(Posn currentPosition, Velocity currentVelocity, int size) {
    super(currentPosition, currentVelocity, size);
  }
  /*
   * Template
   * -----------
   * fields:
   * ... this.currentPosition ... Posn
   * ... this.currentVelocity ... Velocity
   * ... this.size ... int
   * ... this.fishEatenCount ... int
   * 
   * Methods of fields:
   * ... this.currentVelocity.updateVelocity(String keyEvent) ... Velocity
   * ... this.currentVelocity.updateVelocityDrag() ... Velocity
   * ... this.currentVelocity.updatePosn(Posn) ... Posn
   * 
   * Methods:
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
   * 
   * 
   */

  public IFish updateVelocity(String keyEvent) {
    return new BackgroundFish(
        this.currentPosition,
        this.currentVelocity.updateVelocity(keyEvent),
        this.size);
  }

  // reduces velocity of IFish based on a drag constant
  public IFish addDrag() {
    return new BackgroundFish(
        this.currentPosition,
        this.currentVelocity.updateVelocityDrag(),
        this.size);
  }

  // updates the position for each tick
  public IFish updatePosnOnTick() {
    return new BackgroundFish(
        this.currentVelocity.updatePosn(this.currentPosition),
        this.currentVelocity,
        this.size);
  }

  public WorldScene drawFish(WorldScene currentScene) {
    return currentScene.placeImageXY(
        new CircleImage(this.size * this.scaleFactor, OutlineMode.SOLID, Color.RED),
        this.currentPosition.x,
        this.currentPosition.y);
  }

  public IFish eatFish(IFish that) {
    return new BackgroundFish(
        this.currentPosition,
        this.currentVelocity,
        that.combineWeight(this.size));
  }

  public boolean isSame(IFish that) {
    return that.isSameBGFish(this);
  }

  public boolean isBigger(int size) {
    return this.size > size;
  }

  public boolean isSameBGFish(BackgroundFish that) {
    return (this.currentPosition.equals(currentPosition))
        && (this.currentVelocity.equals(that.currentVelocity))
        && (this.size == that.size);
  }

}
