import java.util.Random;
import tester.*; // The tester library
import javalib.worldimages.*; // images, like RectangleImage or OverlayImages
import javalib.funworld.*; // the abstract World class and the big-bang library
import javalib.worldcanvas.WorldCanvas;

import java.awt.Color; // general colors (as triples of red,green,blue values)
// and predefined colors (Red, Green, Yellow, Blue, Black, White)

class FishyGame extends World {

  int width = 960;
  int height = 540;

  String backGroundImg = "src/Sea-Water-Background.jpg";

  Random rand;
  // Represents all the Background fish currently on the canvas
  ILoFish backgroundFish;

  // represents the player
  IFish player;

  /** The constructor */
  public FishyGame(IFish player, ILoFish backgroundFish) {
    this(player, backgroundFish, new Random());
  }

  /** The constructor */
  public FishyGame(IFish player, ILoFish backgroundFish, Random rand) {
    super();
    this.player = player;
    this.backgroundFish = backgroundFish;
    this.rand = rand;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.rand ... Random
   * ... this.backgroundFish ... ILoFish
   * ... this.player ... IFish
   * 
   * Methods of backgroundFish:
   * ... this.drawLoFish(WorldScene currentScene) ... WorldScene
   * ... this.mapUpdatePosnOnTick() ... ILoFish
   * ... this.canBeEaten(IFish thatFish) ... boolean
   * ... this.eatenFish(IFish thatFish) ... IFish
   * ... this.remove(remove(IFish that)) ... ILoFish
   * ... this.canEat(IFish thatFish) ... boolean
   * ... this.eraseFishOutOfBounds(double right, double left, double top, double
   * bottom) ... ILoFish
   * ... this.smallerThan(IFish thatFish) ... boolean
   * ... this.size() ... int
   * 
   * Methods of player
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

  /** Move player when the player presses a key */
  public World onKeyEvent(String ke) {
    if (ke.equals("x")) {
      return this.endOfWorld("Goodbye");
    } else {
      return new FishyGame(this.player.updateVelocity(ke), this.backgroundFish);
    }
  }

  @Override
  public WorldScene makeScene() {
    return this.backgroundFish.drawLoFish(
        this.player.drawFish(
            new WorldScene(this.width, this.height).placeImageXY(
                new ScaleImageXY(
                    new FromFileImage(backGroundImg), .5, .5),
                this.width / 2, this.height / 2)));
  }

  /**
   * On tick move the Blob in a random direction.
   */
  public World onTick() {
    // 1 / frequency = period
    int period = 75;
    int randomTime = (rand.nextInt(period));
    boolean shouldGenerateFish = (randomTime % period - 1 == 0);

    if (this.backgroundFish.canBeEaten(this.player) && shouldGenerateFish) {
      IFish eatenFish = this.backgroundFish.eatenFish(this.player);
      return new FishyGame(this.player
          .updatePosnOnTick()
          .addDrag()
          .eatFish(eatenFish),
          this.backgroundFish
              .eraseFishOutOfBounds(this.width + 1, -1, -1, this.height + 1)
              .remove(eatenFish)
              .mapUpdatePosnOnTick()
              .generateRandomBGFish(new Posn(this.width, this.height), rand));
    } else if (!this.backgroundFish.canBeEaten(this.player) && shouldGenerateFish) {
      return new FishyGame(this.player
          .updatePosnOnTick()
          .addDrag(),
          this.backgroundFish
              .eraseFishOutOfBounds(this.width + 1, -1, -1, this.height + 1)
              .mapUpdatePosnOnTick()
              .generateRandomBGFish(new Posn(this.width, this.height), rand));
    } else if (this.backgroundFish.canBeEaten(this.player) && !shouldGenerateFish) {
      IFish eatenFish = this.backgroundFish.eatenFish(this.player);
      return new FishyGame(this.player
          .updatePosnOnTick()
          .addDrag()
          .eatFish(eatenFish),
          this.backgroundFish
              .eraseFishOutOfBounds(this.width + 1, -1, -1, this.height + 1)
              .remove(eatenFish)
              .mapUpdatePosnOnTick());
    } else {
      return new FishyGame(this.player.updatePosnOnTick().addDrag(),
          this.backgroundFish
              .eraseFishOutOfBounds(this.width + 1, -1, -1, this.height + 1)
              .mapUpdatePosnOnTick());
    }
    // new BlobWorldFun(this.blob.randomMove(5));
  }

  /** produce the last image of this world by adding text to the image */
  public WorldScene lastScene(String s) {
    return this.makeScene()
        .placeImageXY(
            new ScaleImage(
                new TextImage(s, Color.red), 7),
            this.width / 2,
            this.height / 2);
  }

  /**
   * Check whether the Blob is out of bounds, or fell into the black hole in
   * the middle.
   */
  public WorldEnd worldEnds() {
    // if the blob is outside the canvas, stop
    if (this.backgroundFish.canEat(this.player)) {
      return new WorldEnd(true,
          this.lastScene("YOU WERE EATEN!"));
    }
    if (this.backgroundFish.smallerThan(this.player)
        && this.backgroundFish.size() > 0) {
      return new WorldEnd(true, this.lastScene("YOU WIN"));
    } else {
      return new WorldEnd(false, this.makeScene());
    }
  }
}

class ExamplesFishy {
  int width = 960;
  int height = 540;

  String backGroundImg = "src/Sea-Water-Background.jpg";

  PlayerFish exPlayer1 = new PlayerFish(
      new Posn(250, 250), new Velocity(0, 0), 1, 0);
  PlayerFish exPlayer1Left = new PlayerFish(
      new Posn(250, 250), new Velocity(-3, 0), 1, 0);
  PlayerFish exPlayer1LeftPost = new PlayerFish(
      new Posn(247, 250), new Velocity(-3, 0), 1, 0);

  PlayerFish exPlayer1Right = new PlayerFish(
      new Posn(250, 250), new Velocity(3, 0), 1, 0);
  PlayerFish exPlayer1Up = new PlayerFish(
      new Posn(250, 250), new Velocity(0, -3), 1, 0);
  PlayerFish exPlayer1Down = new PlayerFish(
      new Posn(250, 250), new Velocity(0, 3), 1, 0);

  BackgroundFish exNPC1 = new BackgroundFish(new Posn(250, 0), new Velocity(0, 0), 1);
  BackgroundFish exNPC2 = new BackgroundFish(new Posn(250, 500), new Velocity(1, 0), 3);
  BackgroundFish exNPC3 = new BackgroundFish(new Posn(200, 0), new Velocity(0, 3), 8);
  BackgroundFish exNPC4 = new BackgroundFish(new Posn(250, 250), new Velocity(0, 3), 8);
  BackgroundFish exNPC5 = new BackgroundFish(new Posn(250, 1000), new Velocity(0, 3), 8);
  BackgroundFish exNPC6 = new BackgroundFish(new Posn(1000, 250), new Velocity(0, 3), 8);
  BackgroundFish exNPC7 = new BackgroundFish(new Posn(-2, 250), new Velocity(0, 3), 8);
  ConsLoFish exBackgroundFishList = new ConsLoFish(exNPC1,
      new ConsLoFish(exNPC2,
          new ConsLoFish(exNPC3, new MtLoFish())));
  BackgroundFish exNPC1Post = new BackgroundFish(new Posn(250, 0), new Velocity(0, 0), 1);
  BackgroundFish exNPC2Post = new BackgroundFish(new Posn(251, 500), new Velocity(1, 0), 3);
  BackgroundFish exNPC3Post = new BackgroundFish(new Posn(200, 3), new Velocity(0, 3), 8);
  BackgroundFish exNPC4Post = new BackgroundFish(new Posn(250, 253), new Velocity(0, 3), 8);
  ConsLoFish exBackgroundFishListPost = new ConsLoFish(exNPC1Post,
      new ConsLoFish(exNPC2Post,
          new ConsLoFish(exNPC3Post, new MtLoFish())));

  FishyGame exGame = new FishyGame(exPlayer1, exBackgroundFishList);
  FishyGame exGameRandom = new FishyGame(exPlayer1, exBackgroundFishList, new Random(12));
  FishyGame exGameLeft = new FishyGame(exPlayer1Left, exBackgroundFishList);
  FishyGame exGameLeftPost = new FishyGame(exPlayer1LeftPost, exBackgroundFishListPost);

  FishyGame exGamePlayerLoss = new FishyGame(exPlayer1, new ConsLoFish(exNPC4, new MtLoFish()));

  FishyGame exGameRight = new FishyGame(exPlayer1Right, exBackgroundFishList);
  FishyGame exGameUp = new FishyGame(exPlayer1Up, exBackgroundFishList);
  FishyGame exGameDown = new FishyGame(exPlayer1Down, exBackgroundFishList);

  WorldScene emptyScene = new WorldScene(this.width, this.height).placeImageXY(
      new ScaleImageXY(
          new FromFileImage(backGroundImg), .5, .5),
      this.width / 2, this.height / 2);

  /** test the method onKeyEvent in the BlobWorldFun class */
  boolean testOnKeyEvent(Tester t) {
    return t.checkExpect(this.exGame.onKeyEvent("left"), this.exGameLeft,
        "test movePlayer - left " + "\n")
        && t.checkExpect(this.exGame.onKeyEvent("right"), this.exGameRight,
            "test movePlayer - right " + "\n")
        && t.checkExpect(this.exGame.onKeyEvent("up"), this.exGameUp,
            "test movePlayer - up " + "\n")
        && t.checkExpect(this.exGame.onKeyEvent("down"), this.exGameDown,
            "test movePlayer - down " + "\n")
        && t.checkExpect(this.exGame.onKeyEvent("x"), this.exGame.endOfWorld("Goodbye"));
  }

  boolean testMovePlayer(Tester t) {
    return t.checkExpect(this.exPlayer1.updateVelocity("left"), this.exPlayer1Left,
        "test movePlayer - left " + "\n")
        && t.checkExpect(this.exPlayer1.updateVelocity("right"), this.exPlayer1Right,
            "test movePlayer - right " + "\n")
        && t.checkExpect(this.exPlayer1.updateVelocity("up"), this.exPlayer1Up,
            "test movePlayer - up " + "\n")
        && t.checkExpect(this.exPlayer1.updateVelocity("down"), this.exPlayer1Down,
            "test movePlayer - down " + "\n");
  }

  boolean testChangePlayerPosn(Tester t) {
    return t.checkExpect(this.exPlayer1Left.updatePosnOnTick(), this.exPlayer1LeftPost,
        "test movePlayer - left " + "\n");
  }

  boolean testChangeBGPosn(Tester t) {
    return t.checkExpect(this.exBackgroundFishList.mapUpdatePosnOnTick(),
        new ConsLoFish(exNPC1.updatePosnOnTick(),
            new ConsLoFish(exNPC2.updatePosnOnTick(),
                new ConsLoFish(exNPC3.updatePosnOnTick(), new MtLoFish()))),
        "test movePlayer - left " + "\n");
  }

  boolean testChangeBGPosn1(Tester t) {
    return t.checkExpect(
        this.exBackgroundFishList.mapUpdatePosnOnTick(),
        this.exBackgroundFishListPost,
        "test movePlayer - left " + "\n");
  }

  boolean testGenBGFish(Tester t) {
    BackgroundFish randomFish = (BackgroundFish) ((ConsLoFish) (new MtLoFish())
        .generateRandomBGFish(new Posn(this.width, this.height), new Random(12))).first;
    return t.checkOneOf(randomFish.size, 1, 2, 3, 4, 5) &&
        t.checkOneOf(randomFish.currentVelocity.x, 1.0, -1.0) &&
        t.checkOneOf(randomFish.currentPosition.x, 0, this.width) &&
        t.checkExpect(randomFish.currentPosition.y, 16);
  }

  boolean testisSameTester(Tester t) {
    return t.checkExpect(this.exPlayer1.isSame(exNPC1), false)
        && t.checkExpect(this.exNPC1.isSame(exNPC1), true);
  }

  boolean testRemoveFish(Tester t) {
    return t.checkExpect(
        (new MtLoFish()).remove(this.exNPC1),
        new MtLoFish())
        && t.checkExpect(
            exBackgroundFishList.remove(exNPC1),
            new ConsLoFish(exNPC2,
                new ConsLoFish(exNPC3, new MtLoFish())));
  }

  boolean testAddDrag(Tester t) {
    return t.checkExpect(
        this.exPlayer1Right.addDrag(),
        new PlayerFish(
            new Posn(250, 250), new Velocity(2.9, 0), 1, 0))
        &&
        t.checkExpect(
            this.exPlayer1Left.addDrag(),
            new PlayerFish(
                new Posn(250, 250), new Velocity(-2.9, 0), 1, 0))
        &&
        t.checkExpect(
            this.exPlayer1Up.addDrag(),
            new PlayerFish(
                new Posn(250, 250), new Velocity(0, -2.8), 1, 0))
        &&
        t.checkExpect(
            this.exPlayer1Down.addDrag(),
            new PlayerFish(
                new Posn(250, 250), new Velocity(0, 2.8), 1, 0));
  }

  boolean testAddEatFish(Tester t) {
    return t.checkExpect(
        this.exPlayer1Right.eatFish(exNPC1),
        new PlayerFish(
            new Posn(250, 250), new Velocity(3, 0), 2, 1))
        &&
        t.checkExpect(
            this.exPlayer1Right.eatFish(exNPC3),
            new PlayerFish(
                new Posn(250, 250), new Velocity(3, 0), 9, 1));
  }

  boolean testCombineWeight(Tester t) {
    return t.checkExpect(
        this.exPlayer1Right.combineWeight(this.exPlayer1.size),
        2) &&
        t.checkExpect(
            this.exPlayer1Right.combineWeight(81),
            82);
  }

  // testing the drawFish Method
  boolean testPlaceFish(Tester t) {
    return t.checkExpect(
        this.exPlayer1Right.outsideBounds(
            (double) this.width, 0, 0,
            (double) this.height),
        false)
        && t.checkExpect(new PlayerFish(
            new Posn(250, 10000),
            new Velocity(100, 0), 1, 0)
                .outsideBounds((double) this.width, 0, 0,
                    (double) this.height),
            true);
  }

  boolean testWorldEnds(Tester t) {
    return t.checkExpect(
        this.exGamePlayerLoss.worldEnds(),
        new WorldEnd(true,
            this.exGamePlayerLoss.lastScene(("YOU WERE EATEN!"))))
        &&
        t.checkExpect(
            this.exGame.worldEnds(),
            new WorldEnd(false, this.exGame.makeScene()));
  }

  boolean testOutofBound(Tester t) {
    return t.checkExpect(
        (new ConsLoFish(
            this.exNPC5,
            new ConsLoFish(
                this.exNPC6,
                new MtLoFish()))).eraseFishOutOfBounds(this.width, 0, 0, this.height),
        new MtLoFish()) &&
        t.checkExpect(
            (new ConsLoFish(this.exNPC7, this.exBackgroundFishList))
                .eraseFishOutOfBounds(this.width, 0, 0, this.height),
            this.exBackgroundFishList);
  }

  // used to draw the actual image on a canvas
  boolean testDrawFishyGame(Tester t) {
    int x = 960;
    int y = 540;
    WorldCanvas c = new WorldCanvas(x, y);
    WorldScene s = new WorldScene(x, y);

    FishyGame w = new FishyGame(
        new PlayerFish(
            new Posn(250, 250), new Velocity(0, 0), 1, 0),
        new MtLoFish(),
        new Random(12));

    return w.bigBang(x, y, .03);
  }

}