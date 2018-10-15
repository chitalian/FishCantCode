
interface ISelectIF {
  // predicate that returns true if that ImageFile compiles with the pred
  boolean apply(ImageFile that);
}

class smallerThan40000 implements ISelectIF{
  public boolean apply(ImageFile that) {
    return that.size() < 40000;
  }
}

class namesShorterThan4 implements ISelectIF{
  public boolean apply(ImageFile that) {
    return that.name.length() < 4;
  }
}