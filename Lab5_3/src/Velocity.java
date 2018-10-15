import javalib.worldimages.Posn;

public class Velocity {
  double maxVelX = 3;
  double maxVelY = 3;
  double xStep = .1;
  double yStep = .2;

  double dragConst = 1;
  double x;
  double y;

  Velocity() {
    this.x = 0;
    this.y = 0;
  }

  Velocity(double x, double y) {
    this.x = x;
    this.y = y;
  }

  /*
   * Template
   * -----------
   * fields:
   * ... this.x ... int
   * ... this.y ... int
   * 
   * Methods:
   * ... this.updateVelocity(String keyEvent) ... Velocity
   * ... this.updateVelocityDrag() ... Velocity
   * ... this.updatePosn(Posn) ... Posn
   * 
   */

  // Updates the velocity based on a Key Press.
  // Note that the max velocity is
  public Velocity updateVelocity(String keyEvent) {
    if (keyEvent.equals("left") && -1 * this.x < maxVelX) {
      return new Velocity(this.x - maxVelX, this.y);
    } else if (keyEvent.equals("right") && this.x < maxVelX) {
      return new Velocity(this.x + maxVelX, this.y);
    } else if (keyEvent.equals("up") && -1 * this.y < maxVelY) {
      return new Velocity(this.x, this.y - maxVelY);
    } else if (keyEvent.equals("down") && this.y < maxVelY) {
      return new Velocity(this.x, this.y + maxVelY);
    } else {
      return this;
    }
  }

  // updates the velocity based on the drag of the water
  public Velocity updateVelocityDrag() {
    if (this.x < 0) {
      if (this.y < 0) {
        return new Velocity(this.x + xStep / dragConst, this.y + yStep / dragConst);
      } else if (this.y > 0) {
        return new Velocity(this.x + xStep / dragConst, this.y - yStep / dragConst);
      } else {
        return new Velocity(this.x + xStep / dragConst, this.y);
      }
    } else if (this.x > 0) {
      if (this.y < 0) {
        return new Velocity(this.x - xStep / dragConst, this.y + yStep / dragConst);
      } else if (this.y > 0) {
        return new Velocity(this.x - xStep / dragConst, this.y - yStep / dragConst);
      } else {
        return new Velocity(this.x - xStep / dragConst, this.y);
      }
    } else {
      if (this.y < 0) {
        return new Velocity(this.x, this.y + yStep / dragConst);
      } else if (this.y > 0) {
        return new Velocity(this.x, this.y - yStep / dragConst);
      } else {
        return new Velocity(this.x, this.y);
      }
      
    }
  }

  // updates current Posn based on the velocity
  public Posn updatePosn(Posn currentPosn) {
    return new Posn((int) Math.round(currentPosn.x + this.x),
        (int) Math.round(currentPosn.y + this.y));
  }

}
